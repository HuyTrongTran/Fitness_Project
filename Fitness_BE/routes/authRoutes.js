const express = require('express');
const AuthController = require('../controllers/authController');
const UserModel = require('../models/userModel');

const router = express.Router();

// Login route (giữ nguyên)
router.post('/login', AuthController.login);

// Optional: Registration route for testing (giữ nguyên)
router.post('/register', async (req, res, next) => {
  try {
    const user = await UserModel.createUser(req.body);
    res.status(201).json({
      success: true,
      data: user
    });
  } catch (error) {
    next(error);
  }
});

// Logout route (thêm mới)
router.post('/logout', AuthController.logout);

module.exports = router;