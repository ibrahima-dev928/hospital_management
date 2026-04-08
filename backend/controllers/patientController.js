const Patient = require('../models/Patient');
const Rendezvous = require('../models/Rendezvous');
const fs = require('fs').promises;
const Medecin = require('../models/Medecin');

exports.list = async (req, res) => {
  const patients = await Patient.findAll();
  res.render('patients/list', { patients, success: req.query.success, theme: req.session.theme, user: req.session.user });
};

exports.view = async (req, res) => {
  const id = parseInt(req.params.id);
  const patient = await Patient.findById(id);
  if (!patient) return res.redirect('/patients');
  const rdvs = await Rendezvous.findByPatient(id);
  res.render('patients/view', { patient, rdvs, theme: req.session.theme, user: req.session.user });
};

exports.create = async (req, res) => {
  const newPatient = {
    nom: req.body.nom.toUpperCase(),
    prenom: req.body.prenom,
    date_naissance: req.body.date_naissance,
    genre: req.body.genre,
    telephone: req.body.telephone,
    email: req.body.email,
    adresse: req.body.adresse,
    photo: null,
    user_id: null,
    // Nouveaux champs
    groupe_sanguin: req.body.groupe_sanguin,
    allergies: req.body.allergies,
    antecedents: req.body.antecedents,
    traitements_en_cours: req.body.traitements_en_cours,
    medecin_traitant_id: req.body.medecin_traitant_id ? parseInt(req.body.medecin_traitant_id) : null,
    profession: req.body.profession,
    situation_familiale: req.body.situation_familiale,
    numero_securite_sociale: req.body.numero_securite_sociale
  };
  await Patient.create(newPatient);
  res.redirect('/patients?success=Patient ajouté');
};

exports.update = async (req, res) => {
  await Patient.update(req.params.id, req.body);
  res.redirect(`/patients/view/${req.params.id}?success=Modifié`);
};

exports.delete = async (req, res) => {
  const patient = await Patient.findById(req.params.id);
  if (patient && patient.photo) await fs.unlink(patient.photo).catch(() => { });
  await Patient.delete(req.params.id);
  res.redirect('/patients?success=Supprimé');
};

exports.uploadPhoto = async (req, res) => {
  if (req.file) await Patient.updatePhoto(req.params.id, req.file.path);
  res.redirect(`/patients/view/${req.params.id}?success=Photo mise à jour`);
};

exports.deletePhoto = async (req, res) => {
  const patient = await Patient.findById(req.params.id);
  if (patient && patient.photo) await fs.unlink(patient.photo).catch(() => { });
  await Patient.updatePhoto(req.params.id, null);
  res.redirect(`/patients/view/${req.params.id}?success=Photo supprimée`);
};

exports.edit = async (req, res) => {
  const id = parseInt(req.params.id);
  const patient = await Patient.findById(id);
  if (!patient) return res.redirect('/patients?error=Patient introuvable');
  const medecins = await Medecin.findAll(); // Import Medecin en haut du fichier
  res.render('patients/edit', { patient, medecins, title: `Modifier ${patient.prenom} ${patient.nom}` });
};