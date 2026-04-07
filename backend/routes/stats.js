const express = require('express');
const router = express.Router();
const statsController = require('../controllers/statsController');
const { requireAuth } = require('../middleware/auth');

router.get('/', requireAuth, statsController.show);

module.exports = router;