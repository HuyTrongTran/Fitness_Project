const express = require('express');
const router = express.Router();
const { submitRunSession, getRunHistory, getTodayActivity } = require('../controllers/userActivityController');
const { verifyToken } = require('../middleware/auth');

// Route để lấy tổng quãng đường, calories và số bước của ngày hôm nay
router.get('/today', verifyToken, getTodayActivity);

module.exports = router; 