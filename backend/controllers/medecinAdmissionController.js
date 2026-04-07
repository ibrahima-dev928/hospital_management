const Admission = require('../models/Admission');
const Patient = require('../models/Patient');
const Medecin = require('../models/Medecin');
const Chambre = require('../models/Chambre');
const Batiment = require('../models/Batiment');
const Notification = require('../models/Notification');

exports.showAdmissionForm = async (req, res) => {
  const patientId = req.params.id;
  const patient = await Patient.findById(patientId);
  if (!patient) return res.redirect('/medecin/patients');
  const batiments = await Batiment.findAll();
  const chambres = await Chambre.findAvailable();
  res.render('medecin/admission_form', { patient, batiments, chambres, title: `Admission - ${patient.prenom} ${patient.nom}` });
};

exports.getChambresByBatiment = async (req, res) => {
  const batimentId = req.params.id;
  const chambres = await Chambre.findAvailable(batimentId);
  res.json(chambres);
};

exports.createAdmission = async (req, res) => {
  const medecinUser = req.session.user;
  const medecin = await Medecin.findByUserId(medecinUser.id);
  const { patient_id, chambre_id, date_admission, motif } = req.body;
  await Admission.create({
    patient_id,
    medecin_id: medecin.id,
    chambre_id,
    date_admission,
    motif
  });
  // Notification au patient
  const patient = await Patient.findById(patient_id);
  if (patient && patient.user_id) {
    await Notification.create(patient.user_id,
      `Vous avez été admis(e) à l'hôpital le ${new Date(date_admission).toLocaleString('fr-FR')}. Motif : ${motif}.`,
      `/patient/admissions`
    );
  }
  res.redirect('/medecin/admissions?success=Patient admis');
};

exports.listAdmissions = async (req, res) => {
  const medecinUser = req.session.user;
  const medecin = await Medecin.findByUserId(medecinUser.id);
  const admissions = await Admission.findActiveByMedecin(medecin.id);
  res.render('medecin/admissions_list', { admissions, title: 'Admissions en cours' });
};

exports.libererAdmission = async (req, res) => {
  const id = req.params.id;
  const date_sortie = new Date().toISOString().slice(0, 19).replace('T', ' ');
  await Admission.liberer(id, date_sortie);
  // Notification au patient
  const [admission] = await db.query('SELECT patient_id FROM admissions WHERE id = ?', [id]);
  if (admission.length) {
    const patient = await Patient.findById(admission[0].patient_id);
    if (patient && patient.user_id) {
      await Notification.create(patient.user_id,
        `Votre hospitalisation est terminée. Merci et bon rétablissement.`,
        `/patient/admissions`
      );
    }
  }
  res.redirect('/medecin/admissions?success=Chambre libérée');
};