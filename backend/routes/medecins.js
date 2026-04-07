const express = require('express');
const router = express.Router();
const medecinController = require('../controllers/medecinController');
const { requireAuth } = require('../middleware/auth');
const { upload, optimizeImage } = require('../middleware/upload');

router.get('/', requireAuth, medecinController.list);
router.get('/view/:id', requireAuth, medecinController.view);
router.get('/edit/:id', requireAuth, medecinController.edit);
router.post('/', requireAuth, medecinController.create);
router.post('/update/:id', requireAuth, medecinController.update);
router.get('/delete/:id', requireAuth, medecinController.delete);
router.post('/upload/:id', requireAuth, upload.single('photo'), optimizeImage, medecinController.uploadPhoto);
router.get('/deletephoto/:id', requireAuth, medecinController.deletePhoto);
// Rediriger les requêtes GET accidentelles vers la fiche médecin
router.get('/upload/:id', requireAuth, (req, res) => {
  res.redirect(`/medecins/view/${req.params.id}?error=Utilisez le formulaire pour envoyer une photo.`);
});

module.exports = router;