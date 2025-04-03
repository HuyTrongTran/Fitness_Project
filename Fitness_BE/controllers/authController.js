// controllers/authController.js
const jwt = require('jsonwebtoken');
const { User, UserModel } = require('../models/userModel'); // Sửa import để lấy cả User và UserModel
const fs = require('fs').promises;
const config = require('../config/config');

// Debug: Log để kiểm tra User và UserModel
console.log('User model in authController:', User);
console.log('UserModel in authController:', UserModel);

class AuthController {
    static async login(req, res, next) {
        try {
            // Kiểm tra xem UserModel có được import đúng không
            if (!UserModel) {
                throw new Error('UserModel is undefined. Check the import from userModel.js');
            }

            const { email, password } = req.body;
            if (!email || !password) {
                return res.status(400).json({ success: false, message: 'Email và mật khẩu là bắt buộc' });
            }

            console.log('Đăng nhập với email:', email);
            const user = await UserModel.findByEmail(email);
            if (!user) {
                console.log('Không tìm thấy người dùng với email:', email);
                return res.status(401).json({ success: false, message: 'Thông tin đăng nhập không hợp lệ' });
            }

            console.log('Tìm thấy người dùng:', user.email);
            const isValid = await UserModel.verifyPassword(password, user.password);
            console.log('Kết quả xác minh mật khẩu:', isValid);
            if (!isValid) {
                console.log('Mật khẩu không khớp với email:', email);
                return res.status(401).json({ success: false, message: 'Thông tin đăng nhập không hợp lệ' });
            }

            console.log('Mật khẩu đã được xác minh, đang tạo token...');
            const token = jwt.sign(
                { email: user.email, id: user._id },
                config.JWT_SECRET,
                { expiresIn: '24h' }
            );

            res.status(200).json({
                success: true,
                data: {
                    token,
                    firstName: user.firstName,
                    lastName: user.lastName,
                    userName: user.userName,
                    email: user.email,
                    profile: user.profile,
                    hasCompletedOnboarding: user.hasCompletedOnboarding,
                },
            });
        } catch (error) {
            console.error('Lỗi trong /login:', error);
            res.status(500).json({
                success: false,
                message: error.message || 'Internal server error',
            });
        }
    }

    static async register(req, res, next) {
        try {
            // Check if UserModel is imported correctly
            if (!UserModel) {
                throw new Error('UserModel is undefined. Check the import from userModel.js');
            }

            const { firstName, lastName, userName, email, password } = req.body;
            if (!firstName || !lastName || !userName || !email || !password) {
                return res.status(400).json({ success: false, message: 'All fields are required' });
            }

            console.log('Registering with email:', email);
            const existingEmail = await UserModel.findByEmail(email);
            if (existingEmail) {
                console.log('Email already exists:', email);
                return res.status(400).json({ success: false, message: 'Email already exists' });
            }

            const existingUserName = await UserModel.findByUserName(userName);
            if (existingUserName) {
                console.log('Username already exists:', userName);
                return res.status(400).json({ success: false, message: 'Username already exists' });
            }

            const user = await UserModel.createUser({
                firstName,
                lastName,
                userName,
                email,
                password,
                profile: {},
                hasCompletedOnboarding: false,
            });

            console.log('User created:', user.email);
            const token = jwt.sign(
                { id: user._id },
                process.env.JWT_SECRET || 'your_jwt_secret',
                { expiresIn: '1h' }
            );

            res.status(201).json({
                success: true,
                data: {
                    token,
                    firstName: user.firstName,
                    lastName: user.lastName,
                    userName: user.userName,
                    email: user.email,
                    hasCompletedOnboarding: user.hasCompletedOnboarding,
                },
            });
        } catch (error) {
            console.error('Error in /register:', error);
            res.status(500).json({
                success: false,
                message: error.message || 'Internal server error',
            });
        }
    }

    static async logout(req, res, next) {
        try {
            const token = req.headers.authorization?.split(' ')[1];
            if (!token) {
                return res.status(400).json({ success: false, message: 'No token provided' });
            }

            const blacklistPath = './blacklist.txt';
            await fs.appendFile(blacklistPath, `${token}\n`);

            res.status(200).json({ success: true, message: 'Logout successful' });
        } catch (error) {
            console.error('Error in /logout:', error);
            res.status(500).json({
                success: false,
                message: error.message || 'Internal server error',
            });
        }
    }

    static async checkBlacklist(req, res, next) {
        try {
            const token = req.headers.authorization?.split(' ')[1];
            if (!token) {
                return res.status(400).json({ success: false, message: 'No token provided' });
            }

            const blacklistPath = './blacklist.txt';
            const blacklist = await fs.readFile(blacklistPath, 'utf-8');
            const blacklistedTokens = blacklist.split('\n').filter(t => t.trim() !== '');

            if (blacklistedTokens.includes(token)) {
                return res.status(401).json({ success: false, message: 'Token has been added to the blacklist' });
            }

            const decoded = jwt.verify(token, config.JWT_SECRET);
            req.user = decoded;
            next();
        } catch (error) {
            console.error('Error in checkBlacklist:', error);
            res.status(401).json({
                success: false,
                message: 'Invalid token',
            });
        }
    }

    static async completeOnboarding(req, res, next) {
        try {
            const token = req.headers.authorization?.split(' ')[1];
            if (!token) {
                return res.status(400).json({ success: false, message: 'No token provided' });
            }

            const decoded = jwt.verify(token, config.JWT_SECRET);
            const user = await UserModel.updateOnboardingStatus(decoded.email);

            if (!user) {
                return res.status(404).json({ success: false, message: 'User not found' });
            }

            res.status(200).json({ success: true, message: 'Completed onboarding' });
        } catch (error) {
            console.error('Error in completeOnboarding:', error);
            res.status(500).json({
                success: false,
                message: error.message || 'Internal server error',
            });
        }
    }

    
}

module.exports = AuthController;