const db = require('../models/db');
const Admission = require('../models/Admission');
const Patient = require('../models/Patient');

exports.showMyAdmissions = async (req, res) => {
  const patientUser = req.session.user;
  const patient = await Patient.findByUserId(patientUser.id);
  if (!patient) return res.redirect('/patient/rdv?error=Fiche patient introuvable');
  const active = await Admission.findActiveByPatient(patient.id);
  const historique = await Admission.getHistoriqueByPatient(patient.id);
  res.render('patient/admissions', { active, historique, title: 'Mes hospitalisations' });
};