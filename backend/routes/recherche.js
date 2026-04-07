const express = require('express');
const router = express.Router();
const rechercheController = require('../controllers/rechercheController');
const { requireAuth } = require('../middleware/auth');

router.get('/', requireAuth, rechercheController.search);

module.exports = router;