const Patient = require('../models/Patient');
const Medecin = require('../models/Medecin');
const Rendezvous = require('../models/Rendezvous');

exports.search = async (req, res) => {
  const query = req.query.q;
  const type = req.query.type || 'tous';
  let patients = [], medecins = [], rendezvous = [];

  if (query) {
    if (type === 'tous' || type === 'patients') patients = await Patient.search(query);
    if (type === 'tous' || type === 'medecins') medecins = await Medecin.search(query);
    if (type === 'tous' || type === 'rendezvous') rendezvous = await Rendezvous.search(query);
  }

  res.render('recherche', { query, type, patients, medecins, rendezvous, title: 'Recherche' });
};