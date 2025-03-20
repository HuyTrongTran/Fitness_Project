const jwt = require('jsonwebtoken');
const UserModel = require('../models/userModel');
const fs = require('fs').promises; // Dùng fs để lưu blacklist
const config = require('../config/config');

class AuthController {
  // Hàm login
  static async login(req, res, next) {
    try {
      const { email, password } = req.body;

      if (!email || !password) {
        return res.status(400).json({ success: false, message: 'Email and password are required' });
      }

      const user = await UserModel.findByEmail(email);
      if (!user) {
        return res.status(401).json({ success: false, message: 'Invalid credentials' });
      }

      const isValid = await UserModel.verifyPassword(password, user.password);
      if (!isValid) {
        return res.status(401).json({ success: false, message: 'Invalid credentials' });
      }

      const token = jwt.sign(
        { email: user.email, id: user._id }, // Thêm id nếu cần
        config.JWT_SECRET,
        { expiresIn: '24h' }
      );

      res.status(200).json({
        success: true,
        data: {
          token,
          profile: user.profile
        }
      });
    } catch (error) {
      next(error);
    }
  }

  // Hàm logout
  static async logout(req, res, next) {
    try {
      const token = req.headers.authorization?.split(' ')[1];
      if (!token) {
        return res.status(400).json({ success: false, message: 'No token provided' });
      }

      // Đọc danh sách đen từ file
      let blacklist;
      try {
        blacklist = JSON.parse(await fs.readFile('blacklist.json', 'utf8'));
      } catch (err) {
        blacklist = []; // Nếu file chưa tồn tại, khởi tạo mảng rỗng
      }

      // Thêm token vào danh sách đen
      blacklist.push(token);

      // Ghi lại vào file
      await fs.writeFile('blacklist.json', JSON.stringify(blacklist, null, 2));

      res.status(200).json({ success: true, message: 'Logged out successfully' });
    } catch (error) {
      next(error);
    }
  }

  // Middleware kiểm tra blacklist
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

      // Xác minh token
      const decoded = jwt.verify(token, config.JWT_SECRET);
      req.user = decoded;
      next();
    } catch (error) {
      res.status(401).json({ success: false, message: 'Invalid token' });
    }
  }
}

module.exports = AuthController;