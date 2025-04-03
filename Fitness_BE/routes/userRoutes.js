const UserProfile = require('../controllers/userController');
const express = require('express');
const AuthController = require('../controllers/authController');
const upload = require('../middleware/uploadMiddleware');
const router = express.Router();

router.post('/update-profile', AuthController.checkBlacklist, UserProfile.updateProfile);
router.get('/getProfile', AuthController.checkBlacklist, UserProfile.getProfile);
router.post('/upload-profile-image', AuthController.checkBlacklist, upload.single('image'), UserProfile.uploadProfileImage);

module.exports = router;