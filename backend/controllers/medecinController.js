const Medecin = require('../models/Medecin');
const Rendezvous = require('../models/Rendezvous');
const fs = require('fs').promises;

exports.list = async (req, res) => {
  const medecins = await Medecin.findAll();
  res.render('medecins/list', { medecins, success: req.query.success, title: 'Médecins' });
};

exports.view = async (req, res) => {
  const id = parseInt(req.params.id);
  const medecin = await Medecin.findById(id);
  if (!medecin) return res.redirect('/medecins?error=Médecin introuvable');
  const rdvs = await Rendezvous.findByMedecin(id);
  res.render('medecins/view', { medecin, rdvs, title: `Dr. ${medecin.prenom} ${medecin.nom}` });
};

exports.edit = async (req, res) => {
  const id = parseInt(req.params.id);
  const medecin = await Medecin.findById(id);
  if (!medecin) return res.redirect('/medecins?error=Médecin introuvable');
  res.render('medecins/edit', { medecin, title: `Modifier Dr. ${medecin.prenom} ${medecin.nom}` });
};

exports.create = async (req, res) => {
  await Medecin.create(req.body);
  res.redirect('/medecins?success=Médecin ajouté');
};

exports.update = async (req, res) => {
  await Medecin.update(req.params.id, req.body);
  res.redirect(`/medecins/view/${req.params.id}?success=Modifié`);
};

exports.delete = async (req, res) => {
  const medecin = await Medecin.findById(req.params.id);
  if (medecin && medecin.photo) await fs.unlink(medecin.photo).catch(() => { });
  await Medecin.delete(req.params.id);
  res.redirect('/medecins?success=Supprimé');
};

exports.uploadPhoto = async (req, res) => {
  if (req.file) await Medecin.updatePhoto(req.params.id, req.file.path);
  res.redirect(`/medecins/view/${req.params.id}?success=Photo mise à jour`);
};

exports.deletePhoto = async (req, res) => {
  const medecin = await Medecin.findById(req.params.id);
  if (medecin && medecin.photo) await fs.unlink(medecin.photo).catch(() => { });
  await Medecin.updatePhoto(req.params.id, null);
  res.redirect(`/medecins/view/${req.params.id}?success=Photo supprimée`);
};