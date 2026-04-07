const express = require('express');
const router = express.Router();
const { requireAuth } = require('../middleware/auth');
const Patient = require('../models/Patient');
const Medecin = require('../models/Medecin');
const Rendezvous = require('../models/Rendezvous');
const Notification = require('../models/Notification');

router.get('/', requireAuth, async (req, res) => {
  const user = req.session.user;
  let dashboardData = { title: 'Tableau de bord' };

  if (user.role === 'patient') {
    const patientRecord = await Patient.findByUserId(user.id);
    let rdvs = [];
    if (patientRecord) {
      rdvs = await Rendezvous.findByPatient(patientRecord.id);
    }
    const upcomingRdvs = rdvs
      .filter(rdv => new Date(rdv.date_rdv) >= new Date())
      .sort((a, b) => new Date(a.date_rdv) - new Date(b.date_rdv))
      .slice(0, 3);
    const notifs = await Notification.getNonLues(user.id);
    dashboardData = {
      totalRdvs: rdvs.length,
      upcomingRdvs,
      notifsCount: notifs.length,
      notifs: notifs.slice(0, 3),
      title: 'Tableau de bord'
    };
  }
  else if (user.role === 'medecin') {
    const medecinRecord = await Medecin.findByUserId(user.id);
    let demandes = [], confirmes = [];
    if (medecinRecord) {
      demandes = await Rendezvous.findByMedecin(medecinRecord.id, 'en_attente');
      confirmes = await Rendezvous.findByMedecin(medecinRecord.id, 'confirmé');
    }
    const notifs = await Notification.getNonLues(user.id);
    dashboardData = {
      demandesEnAttente: demandes,
      rdvsConfirmes: confirmes,
      notifsCount: notifs.length,
      notifs: notifs.slice(0, 3),
      title: 'Tableau de bord'
    };
  }
  else if (user.role === 'admin') {
    const totalPatients = (await Patient.findAll()).length;
    const totalMedecins = (await Medecin.findAll()).length;
    const totalRdvs = (await Rendezvous.findAll()).length;
    dashboardData = {
      totalPatients,
      totalMedecins,
      totalRdvs,
      title: 'Tableau de bord'
    };
  }

  res.render('dashboard', dashboardData);
});

module.exports = router;