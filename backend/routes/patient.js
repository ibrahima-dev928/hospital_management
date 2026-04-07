const express = require('express');
const router = express.Router();
const { requireAuth } = require('../middleware/auth');
const patientRdvController = require('../controllers/patientRdvController');
const patientDossierController = require('../controllers/patientDossierController');
const patientAdmissionController = require('../controllers/patientAdmissionController');
const factureController = require('../controllers/factureController');

// Rendez-vous
router.get('/prendre-rdv', requireAuth, patientRdvController.showTakeRdv);
router.post('/prendre-rdv', requireAuth, patientRdvController.createRdv);
router.get('/rdv', requireAuth, patientRdvController.listMyRdvs);
router.get('/api/disponibilites/:id', requireAuth, patientRdvController.getDisponibilites);
router.get('/notifications', requireAuth, patientRdvController.showNotifications);

// Dossier médical
router.get('/mon-dossier', requireAuth, patientDossierController.showMyDossier);

// Admissions
router.get('/admissions', requireAuth, patientAdmissionController.showMyAdmissions);

// Factures
router.get('/factures', requireAuth, factureController.listForPatient);
router.get('/facture/:id', requireAuth, factureController.detail);
router.get('/facture/payer/:id', requireAuth, factureController.payer);

module.exports = router;