const db = require('../models/db');
const Batiment = require('../models/Batiment');
const Chambre = require('../models/Chambre');

// ========== BÂTIMENTS ==========
exports.listBatiments = async (req, res) => {
  const batiments = await Batiment.findAll();
  res.render('admin/batiments', { batiments, title: 'Gestion des bâtiments' });
};

exports.createBatimentForm = (req, res) => {
  res.render('admin/batiment_form', { batiment: null, title: 'Ajouter un bâtiment' });
};

exports.createBatiment = async (req, res) => {
  const { nom, description } = req.body;
  await Batiment.create(nom, description);
  res.redirect('/admin/batiments?success=Bâtiment ajouté');
};

exports.editBatimentForm = async (req, res) => {
  const batiment = await Batiment.findById(req.params.id);
  res.render('admin/batiment_form', { batiment, title: 'Modifier un bâtiment' });
};

exports.updateBatiment = async (req, res) => {
  const { nom, description, actif } = req.body;
  await Batiment.update(req.params.id, nom, description, actif === 'on' ? 1 : 0);
  res.redirect('/admin/batiments?success=Bâtiment modifié');
};

exports.deleteBatiment = async (req, res) => {
  await Batiment.delete(req.params.id);
  res.redirect('/admin/batiments?success=Bâtiment supprimé');
};

// ========== CHAMBRES ==========
exports.listChambres = async (req, res) => {
  const chambres = await Chambre.findAll();
  const batiments = await Batiment.findAll();
  res.render('admin/chambres', { chambres, batiments, title: 'Gestion des chambres' });
};

exports.createChambreForm = async (req, res) => {
  const batiments = await Batiment.findAll();
  res.render('admin/chambre_form', { chambre: null, batiments, title: 'Ajouter une chambre' });
};

exports.createChambre = async (req, res) => {
  const { batiment_id, numero, type, capacite } = req.body;
  await Chambre.create({ batiment_id, numero, type, capacite });
  res.redirect('/admin/chambres?success=Chambre ajoutée');
};

exports.editChambreForm = async (req, res) => {
  const chambre = await Chambre.findById(req.params.id);
  const batiments = await Batiment.findAll();
  res.render('admin/chambre_form', { chambre, batiments, title: 'Modifier une chambre' });
};

exports.updateChambre = async (req, res) => {
  const { batiment_id, numero, type, capacite, actif } = req.body;
  await Chambre.update(req.params.id, { batiment_id, numero, type, capacite, actif: actif === 'on' ? 1 : 0 });
  res.redirect('/admin/chambres?success=Chambre modifiée');
};

exports.deleteChambre = async (req, res) => {
  await Chambre.delete(req.params.id);
  res.redirect('/admin/chambres?success=Chambre supprimée');
};