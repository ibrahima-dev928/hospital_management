const express = require('express');
const router = express.Router();
const { requireAuth, requireAdmin } = require('../../middleware/auth');
const adminRechercheController = require('../../controllers/adminRechercheController');

router.get('/', requireAuth, requireAdmin, adminRechercheController.recherche);

module.exports = router;