const express = require('express');
const router = express.Router();
const { requireAuth, requireAdmin } = require('../../middleware/auth');
const userController = require('../../controllers/userController');

router.get('/', requireAuth, requireAdmin, userController.list);
router.get('/new', requireAuth, requireAdmin, userController.createForm);
router.post('/', requireAuth, requireAdmin, userController.create);
router.get('/edit/:id', requireAuth, requireAdmin, userController.editForm);
router.post('/update/:id', requireAuth, requireAdmin, userController.update);
router.get('/delete/:id', requireAuth, requireAdmin, userController.delete);

module.exports = router;