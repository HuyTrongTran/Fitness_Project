const jwt = require('jsonwebtoken');
const fs = require('fs').promises;
const config = require('../config/config');

class AuthMiddleware {
  static async checkBlacklist(req, res, next) {
    const token = req.headers.authorization?.split(' ')[1];
    if (!token) {
      return res.status(401).json({ success: false, message: 'No token provided' });
    }

    try {
      let blacklist = [];
      try {
        blacklist = JSON.parse(await fs.readFile('blacklist.json', 'utf8'));
      } catch (err) {
        // Nếu file không tồn tại, bỏ qua
      }

      if (blacklist.includes(token)) {
        return res.status(401).json({ success: false, message: 'Token has been invalidated' });
      }

      const decoded = jwt.verify(token, config.JWT_SECRET);
      req.user = decoded;
      next();
    } catch (error) {
      res.status(401).json({ success: false, message: 'Invalid token' });
    }
  }
}

module.exports = AuthMiddleware;