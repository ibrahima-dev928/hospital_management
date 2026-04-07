const express = require('express');
const router = express.Router();
const parametresController = require('../controllers/parametresController');
const { requireAuth, requireAdmin } = require('../middleware/auth');

router.get('/', requireAuth, requireAdmin, parametresController.show);
router.post('/', requireAuth, requireAdmin, parametresController.update);

module.exports = router;