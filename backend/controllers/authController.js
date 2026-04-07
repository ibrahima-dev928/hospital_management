const User = require('../models/User');
const Patient = require('../models/Patient'); // Ajout de l'import du modèle Patient

exports.showLogin = (req, res) => {
  const error = req.query.error;
  const redirect = req.query.redirect || '/';
  res.render('login', { error, redirect, title: 'Connexion' });
};

exports.login = async (req, res) => {
  const { username, password, redirect } = req.body;
  const user = await User.findByUsername(username);
  if (user && await User.verifyPassword(password, user.password)) {
    req.session.user = {
      id: user.id,
      username: user.username,
      nom: user.nom,
      prenom: user.prenom,
      email: user.email,
      role: user.role
    };

    // Création automatique de la fiche patient si l'utilisateur est un patient
    if (user.role === 'patient') {
      let patientRecord = await Patient.findByUserId(user.id);
      if (!patientRecord) {
        await Patient.create({
          nom: user.nom,
          prenom: user.prenom,
          email: user.email,
          user_id: user.id
        });
        console.log(`✅ Fiche patient créée automatiquement pour ${user.prenom} ${user.nom}`);
      }
    }

    res.redirect(redirect);
  } else {
    res.redirect(`/login?error=Identifiants incorrects&redirect=${encodeURIComponent(redirect)}`);
  }
};

exports.logout = (req, res) => {
  req.session.destroy(() => {
    res.redirect('/login?success=Déconnexion réussie');
  });
};

exports.showRegister = (req, res) => {
  res.render('register', { error: null, title: 'Inscription patient' });
};

exports.register = async (req, res) => {
  const { username, password, confirm_password, email, nom, prenom, telephone, adresse, date_naissance, genre } = req.body;
  if (password !== confirm_password) {
    return res.render('register', { error: 'Les mots de passe ne correspondent pas', title: 'Inscription' });
  }
  const existing = await User.findByUsername(username);
  if (existing) {
    return res.render('register', { error: 'Nom d\'utilisateur déjà pris', title: 'Inscription' });
  }
  // Créer l'utilisateur
  const userId = await User.create({ username, password, email, role: 'patient', nom, prenom });
  // Créer la fiche patient associée
  await Patient.create({
    nom, prenom,
    date_naissance: date_naissance || null,
    genre: genre || null,
    telephone: telephone || null,
    email: email || null,
    adresse: adresse || null,
    user_id: userId
  });
  // Connecter automatiquement
  req.session.user = { id: userId, username, nom, prenom, email, role: 'patient' };
  res.redirect('/');
};