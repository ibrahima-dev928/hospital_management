const db = require('../models/db');
const DossierMedical = require('../models/DossierMedical');
const Patient = require('../models/Patient');

exports.showMyDossier = async (req, res) => {
  const patientUser = req.session.user;
  const patient = await Patient.findByUserId(patientUser.id);
  if (!patient) {
    return res.redirect('/patient/rdv?error=Fiche patient introuvable');
  }
  const [dossiers] = await db.query(`
        SELECT d.*, m.nom, m.prenom, m.specialite
        FROM dossiers_medicaux d
        JOIN medecins m ON d.medecin_id = m.id
        WHERE d.patient_id = ?
    `, [patient.id]);
  const prescriptionsByMedecin = [];
  for (const dossier of dossiers) {
    const prescriptions = await DossierMedical.getPrescriptionsByDossier(dossier.id);
    prescriptionsByMedecin.push({
      medecin: `${dossier.prenom} ${dossier.nom} (${dossier.specialite})`,
      prescriptions
    });
  }
  res.render('patient/dossier', { prescriptionsByMedecin, title: 'Mon dossier médical' });
};