const express = require('express');
const router = express.Router();
const { requireAuth, requireMedecin } = require('../middleware/auth');
const medecinController = require('../controllers/medecinDashboardController');
const medecinDossierController = require('../controllers/medecinDossierController');
const medecinAdmissionController = require('../controllers/medecinAdmissionController');
const factureController = require('../controllers/factureController');

// Tableau de bord et gestion des rendez-vous
router.get('/dashboard', requireAuth, requireMedecin, medecinController.dashboard);
router.get('/confirm-rdv/:id', requireAuth, requireMedecin, medecinController.confirmRdv);
router.get('/refuse-rdv/:id', requireAuth, requireMedecin, medecinController.refuseRdv);
router.get('/disponibilites', requireAuth, requireMedecin, medecinController.disponibilites);
router.post('/disponibilites', requireAuth, requireMedecin, medecinController.addDisponibilite);
router.get('/notif/read/:id', requireAuth, requireMedecin, medecinController.markNotifAsRead);

// Dossiers médicaux et prescriptions
router.get('/patients', requireAuth, requireMedecin, medecinDossierController.patientList);
router.get('/dossier/:id', requireAuth, requireMedecin, medecinDossierController.showDossier);
router.post('/dossier/:id/prescription', requireAuth, requireMedecin, medecinDossierController.addPrescription);
router.get('/prescription/delete/:id', requireAuth, requireMedecin, medecinDossierController.deletePrescription);
router.get('/admissions', requireAuth, requireMedecin, medecinAdmissionController.listAdmissions);
router.get('/admission/patient/:id', requireAuth, requireMedecin, medecinAdmissionController.showAdmissionForm);
router.get('/api/chambres/batiment/:id', requireAuth, requireMedecin, medecinAdmissionController.getChambresByBatiment);
router.post('/admission', requireAuth, requireMedecin, medecinAdmissionController.createAdmission);
router.get('/admission/liberer/:id', requireAuth, requireMedecin, medecinAdmissionController.libererAdmission);
router.get('/factures', requireAuth, requireMedecin, factureController.listForMedecin);
router.get('/facture/patient/:patientId', requireAuth, requireMedecin, factureController.showCreateForm);
router.post('/facture', requireAuth, requireMedecin, factureController.create);
router.get('/facture/:id', requireAuth, requireMedecin, factureController.detail);

module.exports = router;