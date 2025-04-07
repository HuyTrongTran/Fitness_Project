const jwt = require('jsonwebtoken');
const config = require('../config/config');

const authenticateToken = (req, res, next) => {
    const authHeader = req.headers['authorization'];
    const token = authHeader && authHeader.split(' ')[1];

    if (!token) {
        return res.status(401).json({
            success: false,
            message: 'Access token not found'
        });
    }

    try {
        const decoded = jwt.verify(token, config.jwtSecret);
        req.user = decoded;
        next();
    } catch (error) {
        console.error('Token verification failed:', error);
        return res.status(403).json({
            success: false,
            message: 'Invalid or expired token'
        });
    }
};

module.exports = { authenticateToken }; 