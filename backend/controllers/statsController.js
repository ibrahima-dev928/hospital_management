const Patient = require('../models/Patient');
const Medecin = require('../models/Medecin');
const Rendezvous = require('../models/Rendezvous');

exports.show = async (req, res) => {
  const totalPatients = (await Patient.findAll()).length;
  const totalMedecins = (await Medecin.findAll()).length;
  const rdvStats = await Rendezvous.getStats();
  const medecins = await Medecin.findAll();
  const specialites = {};
  medecins.forEach(m => {
    specialites[m.specialite] = (specialites[m.specialite] || 0) + 1;
  });
  res.render('stats', {
    totalPatients,
    totalMedecins,
    rdvStats,
    specialites,
    title: 'Statistiques'
  });
};