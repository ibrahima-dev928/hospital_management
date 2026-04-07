const Rendezvous = require('../models/Rendezvous');
const Patient = require('../models/Patient');
const Medecin = require('../models/Medecin');

exports.list = async (req, res) => {
  let rendezvous;
  const user = req.session.user;
  if (user.role === 'medecin') {
    const medecin = await Medecin.findByUserId(user.id);
    rendezvous = await Rendezvous.findByMedecin(medecin.id);
  } else {
    rendezvous = await Rendezvous.findAll();
  }
  const patients = await Patient.findAll();
  const medecins = await Medecin.findAll();
  res.render('rendezvous/list', { rendezvous, patients, medecins, success: req.query.success, title: 'Rendez-vous' });
};

exports.view = async (req, res) => {
  const id = parseInt(req.params.id);
  const rdv = await Rendezvous.findById(id);
  if (!rdv) return res.redirect('/rendezvous?error=Rendez-vous introuvable');
  const patient = await Patient.findById(rdv.patient_id);
  const medecin = await Medecin.findById(rdv.medecin_id);
  res.render('rendezvous/view', { rdv, patient, medecin, title: `Rendez-vous #${rdv.id}` });
};

exports.edit = async (req, res) => {
  const id = parseInt(req.params.id);
  const rdv = await Rendezvous.findById(id);
  if (!rdv) return res.redirect('/rendezvous?error=Rendez-vous introuvable');
  const patients = await Patient.findAll();
  const medecins = await Medecin.findAll();
  res.render('rendezvous/edit', { rdv, patients, medecins, title: `Modifier RDV #${rdv.id}` });
};

exports.create = async (req, res) => {
  await Rendezvous.create(req.body);
  res.redirect('/rendezvous?success=Rendez-vous ajouté');
};

exports.update = async (req, res) => {
  await Rendezvous.update(req.params.id, req.body);
  res.redirect(`/rendezvous/view/${req.params.id}?success=Modifié`);
};

exports.delete = async (req, res) => {
  await Rendezvous.delete(req.params.id);
  res.redirect('/rendezvous?success=Supprimé');
};