const db = require('../models/db');
const DossierMedical = require('../models/DossierMedical');
const Patient = require('../models/Patient');
const Medecin = require('../models/Medecin');
const Notification = require('../models/Notification');

exports.patientList = async (req, res) => {
  const medecinUser = req.session.user;
  const medecin = await Medecin.findByUserId(medecinUser.id);
  if (!medecin) return res.status(404).send('Médecin non trouvé');
  const [patients] = await db.query(`
        SELECT DISTINCT p.* FROM patients p
        JOIN rendezvous r ON p.id = r.patient_id
        WHERE r.medecin_id = ? AND r.statut = 'confirmé'
        ORDER BY p.nom
    `, [medecin.id]);
  res.render('medecin/patients_list', { patients, title: 'Mes patients' });
};

exports.showDossier = async (req, res) => {
  const medecinUser = req.session.user;
  const medecin = await Medecin.findByUserId(medecinUser.id);
  const patientId = req.params.id;
  const patient = await Patient.findById(patientId);
  if (!patient) return res.redirect('/medecin/patients');
  const dossier = await DossierMedical.getOrCreate(patientId, medecin.id);
  const prescriptions = await DossierMedical.getPrescriptionsByDossier(dossier.id);
  res.render('medecin/dossier', { patient, prescriptions, dossier, title: `Dossier médical - ${patient.prenom} ${patient.nom}` });
};

exports.addPrescription = async (req, res) => {
  const medecinUser = req.session.user;
  const medecin = await Medecin.findByUserId(medecinUser.id);
  const patientId = req.params.id;
  const { date_prescription, contenu, medicaments, posologie, duree, remarques } = req.body;
  const dossier = await DossierMedical.getOrCreate(patientId, medecin.id);
  await DossierMedical.addPrescription(dossier.id, { date_prescription, contenu, medicaments, posologie, duree, remarques });
  const patient = await Patient.findById(patientId);
  if (patient && patient.user_id) {
    await Notification.create(patient.user_id,
      `Nouvelle prescription ajoutée par Dr. ${medecinUser.prenom} ${medecinUser.nom} le ${new Date(date_prescription).toLocaleDateString('fr-FR')}. Consultez votre dossier médical.`,
      `/patient/mon-dossier`
    );
  }
  res.redirect(`/medecin/dossier/${patientId}?success=Prescription ajoutée`);
};

exports.deletePrescription = async (req, res) => {
  const prescriptionId = req.params.id;
  const medecinUser = req.session.user;
  const medecin = await Medecin.findByUserId(medecinUser.id);
  const [rows] = await db.query(`
        SELECT p.* FROM prescriptions p
        JOIN dossiers_medicaux d ON p.dossier_medical_id = d.id
        WHERE p.id = ? AND d.medecin_id = ?
    `, [prescriptionId, medecin.id]);
  if (rows.length === 0) return res.status(403).send('Accès non autorisé');
  await db.query('DELETE FROM prescriptions WHERE id = ?', [prescriptionId]);
  res.redirect('back');
};