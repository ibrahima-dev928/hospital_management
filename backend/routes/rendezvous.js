const express = require('express');
const router = express.Router();
const rendezvousController = require('../controllers/rendezvousController');
const { requireAuth } = require('../middleware/auth');

router.get('/', requireAuth, rendezvousController.list);
router.get('/view/:id', requireAuth, rendezvousController.view);
router.get('/edit/:id', requireAuth, rendezvousController.edit);
router.post('/', requireAuth, rendezvousController.create);
router.post('/update/:id', requireAuth, rendezvousController.update);
router.get('/delete/:id', requireAuth, rendezvousController.delete);

module.exports = router;