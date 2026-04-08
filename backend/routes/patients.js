const express = require('express');
const router = express.Router();
const patientController = require('../controllers/patientController');
const { requireAuth } = require('../middleware/auth');
const { upload, optimizeImage } = require('../middleware/upload');

router.get('/', requireAuth, patientController.list);
router.get('/view/:id', requireAuth, patientController.view);
router.post('/', requireAuth, patientController.create);
router.post('/update/:id', requireAuth, patientController.update);
router.get('/delete/:id', requireAuth, patientController.delete);
router.post('/upload/:id', requireAuth, upload.single('photo'), optimizeImage, patientController.uploadPhoto);
router.get('/deletephoto/:id', requireAuth, patientController.deletePhoto);
router.get('/edit/:id', requireAuth, patientController.edit);

module.exports = router;