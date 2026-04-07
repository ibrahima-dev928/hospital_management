const Preference = require('../models/Preference');

exports.show = async (req, res) => {
  const prefs = await Preference.getGlobal();
  res.render('parametres', { prefs, success: req.query.success, title: 'Paramètres' });
};

exports.update = async (req, res) => {
  await Preference.updateGlobal(req.body);
  res.redirect('/parametres?success=Paramètres mis à jour');
};