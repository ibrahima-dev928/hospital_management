const express = require('express');
const session = require('express-session');
const path = require('path');
const dotenv = require('dotenv');
const Preference = require('./models/Preference');

dotenv.config();
const app = express();
const port = process.env.PORT || 7777;

app.use(express.urlencoded({ extended: true }));
app.use(express.json());
app.use(express.static(path.join(__dirname, '../frontend/public')));
app.use('/uploads', express.static('uploads'));

app.use(session({
  secret: process.env.SESSION_SECRET,
  resave: false,
  saveUninitialized: false,
  cookie: { secure: false, maxAge: 24 * 60 * 60 * 1000 }
}));

app.set('view engine', 'ejs');
app.set('views', path.join(__dirname, '../frontend/views'));
// Dans server.js, après app.set('view engine', 'ejs'), ajoutez :
app.use((req, res, next) => {
  res.locals.currentPath = req.path;
  next();
});
// Middleware global : thème + utilisateur
app.use(async (req, res, next) => {
  if (!req.session.theme) {
    const prefs = await Preference.getGlobal();
    req.session.theme = prefs.theme;
  }
  res.locals.theme = req.session.theme;
  res.locals.user = req.session.user;
  next();
});

// Routes
app.use('/', require('./routes/auth'));
app.use('/', require('./routes/index'));
app.use('/patients', require('./routes/patients'));
app.use('/medecins', require('./routes/medecins'));
app.use('/rendezvous', require('./routes/rendezvous'));
app.use('/stats', require('./routes/stats'));
app.use('/recherche', require('./routes/recherche'));
app.use('/parametres', require('./routes/parametres'));
// Routes d'inscription
app.use('/register', require('./routes/auth'));
// Routes patient
app.use('/patient', require('./routes/patient'));
// Routes médecin
app.use('/medecin', require('./routes/medecin'));
app.use('/admin/users', require('./routes/admin/users'));

app.listen(port, '0.0.0.0', () => {
  console.log(`🏥 HOPITAL V6 - MySQL - port ${port}`);
});

app.get('/check-users', async (req, res) => {
  const db = require('./models/db');
  try {
    const [rows] = await db.query('SELECT id, username, role FROM users');
    res.json(rows);
  } catch (err) {
    res.json({ error: err.message });
  }
});

app.get('/test-db', async (req, res) => {
  const db = require('./models/db');
  try {
    const [rows] = await db.query('SELECT COUNT(*) as count FROM users');
    res.send(`Connexion OK, nombre d'utilisateurs : ${rows[0].count}`);
  } catch (err) {
    res.send(`Erreur : ${err.message}`);
  }
});

app.use('/admin/batiments', require('./routes/admin/batiments'));
app.use('/admin/chambres', require('./routes/admin/chambres'));