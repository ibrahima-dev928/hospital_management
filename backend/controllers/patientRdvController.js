const Rendezvous = require('../models/Rendezvous');
const Medecin = require('../models/Medecin');
const Disponibilite = require('../models/Disponibilite');
const Patient = require('../models/Patient');
const Notification = require('../models/Notification');

exports.showTakeRdv = async (req, res) => {
  const medecins = await Medecin.findAll();
  res.render('patient/take_rdv', { medecins, error: null, success: null, title: 'Prendre rendez-vous' });
};

exports.getDisponibilites = async (req, res) => {
  const medecinId = req.params.id;
  const dispos = await Disponibilite.findByMedecin(medecinId);
  res.json(dispos);
};

exports.createRdv = async (req, res) => {
  const { medecin_id, date_rdv, heure_rdv, motif } = req.body;
  const patientUser = req.session.user;
  const patientRecord = await Patient.findByUserId(patientUser.id);
  if (!patientRecord) {
    return res.status(400).send('Patient non trouvé. Votre compte n\'est pas lié à une fiche patient. Contactez l\'administrateur.');
  }
  await Rendezvous.createWithUser({
    patient_id: patientRecord.id,
    medecin_id,
    date_rdv,
    heure_rdv,
    motif
  });
  res.redirect('/patient/rdv?success=Demande envoyée');
};

exports.listMyRdvs = async (req, res) => {
  const patientUser = req.session.user;
  let patientRecord = await Patient.findByUserId(patientUser.id);
  if (!patientRecord) {
    const newId = await Patient.create({
      nom: patientUser.nom,
      prenom: patientUser.prenom,
      email: patientUser.email,
      user_id: patientUser.id
    });
    patientRecord = { id: newId };
  }
  const rdvs = await Rendezvous.findByPatient(patientRecord.id);
  res.render('patient/my_rdvs', { rdvs, title: 'Mes rendez-vous' });
};

exports.showNotifications = async (req, res) => {
  const userId = req.session.user.id;
  const notifs = await Notification.getAll(userId);
  res.render('patient/notifications', { notifs, title: 'Mes notifications' });
};