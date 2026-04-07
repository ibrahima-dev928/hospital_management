const db = require('../models/db');
const Facture = require('../models/Facture');
const Patient = require('../models/Patient');
const Medecin = require('../models/Medecin');
const Notification = require('../models/Notification');

// Liste des factures pour le médecin
exports.listForMedecin = async (req, res) => {
  const medecinUser = req.session.user;
  const medecin = await Medecin.findByUserId(medecinUser.id);
  const [factures] = await db.query(`
        SELECT f.*, p.nom as patient_nom, p.prenom as patient_prenom
        FROM factures f
        JOIN patients p ON f.patient_id = p.id
        WHERE f.medecin_id = ?
        ORDER BY f.date_emission DESC
    `, [medecin.id]);
  res.render('medecin/factures_list', { factures, title: 'Mes factures' });
};

// Formulaire de création (par médecin)
exports.showCreateForm = async (req, res) => {
  const patientId = req.params.patientId;
  const patient = await Patient.findById(patientId);
  if (!patient) return res.redirect('/medecin/patients');
  res.render('medecin/facture_form', { patient, title: `Facturation - ${patient.prenom} ${patient.nom}` });
};

// Créer une facture
exports.create = async (req, res) => {
  const medecinUser = req.session.user;
  const medecin = await Medecin.findByUserId(medecinUser.id);
  const { patient_id, date_emission, date_echeance, motif, lignes } = req.body;
  const parsedLignes = JSON.parse(lignes);
  await Facture.create({
    patient_id,
    medecin_id: medecin.id,
    date_emission,
    date_echeance,
    motif
  }, parsedLignes);
  const patient = await Patient.findById(patient_id);
  if (patient.user_id) {
    await Notification.create(patient.user_id,
      `Une nouvelle facture a été émise. Consultez-la dans votre espace.`,
      `/patient/factures`
    );
  }
  res.redirect('/medecin/factures?success=Facture créée');
};

// Détail d'une facture (accessible aussi au médecin)
exports.detail = async (req, res) => {
  const id = req.params.id;
  const facture = await Facture.findById(id);
  if (!facture) return res.status(404).send('Facture non trouvée');
  const lignes = await Facture.getLignes(id);
  const patient = await Patient.findById(facture.patient_id);
  res.render('facture_detail', { facture, lignes, patient, title: `Facture ${facture.numero_facture}` });
};
// Ajoutez ces méthodes à votre factureController.js existant
exports.listForPatient = async (req, res) => {
  const patientUser = req.session.user;
  const Patient = require('../models/Patient');
  const Facture = require('../models/Facture');
  const patient = await Patient.findByUserId(patientUser.id);
  const factures = await Facture.findByPatient(patient.id);
  res.render('patient/factures', { factures, title: 'Mes factures' });
};

exports.payer = async (req, res) => {
  const Facture = require('../models/Facture');
  const Patient = require('../models/Patient');
  const Notification = require('../models/Notification');
  const id = req.params.id;
  await Facture.payer(id);
  const facture = await Facture.findById(id);
  const patient = await Patient.findById(facture.patient_id);
  if (patient && patient.user_id) {
    await Notification.create(patient.user_id, `Votre facture ${facture.numero_facture} a été réglée. Merci.`, `/patient/factures`);
  }
  res.redirect('/patient/factures?success=Paiement effectué');
};

// Assurez-vous que la méthode detail existe (elle devrait déjà être là)