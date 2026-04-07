const User = require('../models/User');
const bcrypt = require('bcryptjs');

exports.list = async (req, res) => {
  const users = await User.findAll();
  res.render('admin/users', { users, success: req.query.success, title: 'Gestion des utilisateurs' });
};

exports.createForm = (req, res) => {
  res.render('admin/user_form', { user: null, error: null, title: 'Ajouter un utilisateur' });
};

exports.create = async (req, res) => {
  const { username, password, email, role, nom, prenom } = req.body;
  const existing = await User.findByUsername(username);
  if (existing) {
    const users = await User.findAll();
    return res.render('admin/users', { users, error: 'Nom d\'utilisateur déjà pris', title: 'Gestion des utilisateurs' });
  }
  await User.create({ username, password, email, role, nom, prenom });
  res.redirect('/admin/users?success=Utilisateur ajouté');
};

exports.editForm = async (req, res) => {
  const user = await User.findById(req.params.id);
  res.render('admin/user_form', { user, error: null, title: 'Modifier utilisateur' });
};

exports.update = async (req, res) => {
  const { email, role, nom, prenom } = req.body;
  await User.update(req.params.id, { email, role, nom, prenom });
  res.redirect('/admin/users?success=Utilisateur modifié');
};

exports.delete = async (req, res) => {
  await User.delete(req.params.id);
  res.redirect('/admin/users?success=Utilisateur supprimé');
};