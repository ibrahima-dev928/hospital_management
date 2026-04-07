const Rendezvous = require('../models/Rendezvous');
const Notification = require('../models/Notification');
const Disponibilite = require('../models/Disponibilite');
const Medecin = require('../models/Medecin');

exports.dashboard = async (req, res) => {
  const medecinUser = req.session.user;
  const medecin = await Medecin.findByUserId(medecinUser.id);
  const demandes = await Rendezvous.findByMedecin(medecin.id, 'en_attente');
  const confirmes = await Rendezvous.findByMedecin(medecin.id, 'confirmé');
  const notifs = await Notification.getNonLues(medecinUser.id);
  res.render('medecin/dashboard', { demandes, confirmes, notifs, title: 'Espace médecin' });
};

exports.confirmRdv = async (req, res) => {
  const rdvId = req.params.id;
  await Rendezvous.updateStatus(rdvId, 'confirmé');
  const rdv = await Rendezvous.findById(rdvId);
  const patient = await Patient.findById(rdv.patient_id);
  if (patient && patient.user_id) {
    await Notification.create(patient.user_id, `Votre rendez-vous du ${new Date(rdv.date_rdv).toLocaleString('fr-FR')} a été confirmé.`, `/patient/rdv`);
  }
  res.redirect('/medecin/dashboard?success=RDV confirmé');
};

exports.refuseRdv = async (req, res) => {
  const rdvId = req.params.id;
  await Rendezvous.updateStatus(rdvId, 'refusé');
  const rdv = await Rendezvous.findById(rdvId);
  const patient = await Patient.findById(rdv.patient_id);
  if (patient && patient.user_id) {
    await Notification.create(patient.user_id, `Votre rendez-vous du ${new Date(rdv.date_rdv).toLocaleString('fr-FR')} a été refusé.`, `/patient/rdv`);
  }
  res.redirect('/medecin/dashboard?success=RDV refusé');
};

exports.disponibilites = async (req, res) => {
  const medecin = await Medecin.findByUserId(req.session.user.id);
  const dispos = await Disponibilite.findByMedecin(medecin.id);
  res.render('medecin/disponibilites', { dispos, title: 'Mes disponibilités' });
};

exports.addDisponibilite = async (req, res) => {
  const medecin = await Medecin.findByUserId(req.session.user.id);
  await Disponibilite.create({ ...req.body, medecin_id: medecin.id });
  res.redirect('/medecin/disponibilites?success=Disponibilité ajoutée');
};

exports.markNotifAsRead = async (req, res) => {
  await Notification.markAsRead(req.params.id);
  res.redirect('/medecin/dashboard');
};