const express = require('express');
const router = express.Router();
const { requireAuth, requireAdmin } = require('../../middleware/auth');
const adminController = require('../../controllers/adminBatimentChambreController');

router.get('/', requireAuth, requireAdmin, adminController.listChambres);
router.get('/new', requireAuth, requireAdmin, adminController.createChambreForm);
router.post('/', requireAuth, requireAdmin, adminController.createChambre);
router.get('/edit/:id', requireAuth, requireAdmin, adminController.editChambreForm);
router.post('/update/:id', requireAuth, requireAdmin, adminController.updateChambre);
router.get('/delete/:id', requireAuth, requireAdmin, adminController.deleteChambre);

module.exports = router;