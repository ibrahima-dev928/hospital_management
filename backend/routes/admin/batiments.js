const express = require('express');
const router = express.Router();
const { requireAuth, requireAdmin } = require('../../middleware/auth');
const adminBatimentChambreController = require('../../controllers/adminBatimentChambreController');

router.get('/', requireAuth, requireAdmin, adminBatimentChambreController.listBatiments);
router.get('/new', requireAuth, requireAdmin, adminBatimentChambreController.createBatimentForm);
router.post('/', requireAuth, requireAdmin, adminBatimentChambreController.createBatiment);
router.get('/edit/:id', requireAuth, requireAdmin, adminBatimentChambreController.editBatimentForm);
router.post('/update/:id', requireAuth, requireAdmin, adminBatimentChambreController.updateBatiment);
router.get('/delete/:id', requireAuth, requireAdmin, adminBatimentChambreController.deleteBatiment);

module.exports = router;