const express = require('express');
const AuthController = require('../controllers/authController');
const UserModel = require('../models/userModel');
const jwt = require('jsonwebtoken');
const getActivityCalendar = require('../controllers/getActivityCalendar');
const UserProfile = require('../controllers/userController');

const router = express.Router();

router.post('/login', AuthController.login);

router.post('/register', AuthController.register);

router.post('/logout', AuthController.logout);
router.post('/complete-onboarding', AuthController.checkBlacklist, AuthController.completeOnboarding);
router.post('/update-profile', AuthController.checkBlacklist, AuthController.updateProfile);
router.get('/getProfile', AuthController.checkBlacklist, UserProfile.getProfile);
router.get('/activity-data', AuthController.checkBlacklist, getActivityCalendar.getActivityData);

module.exports = router;