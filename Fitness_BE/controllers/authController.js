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
                return res.status(400).json({ success: false, message: 'Không có token được cung cấp' });
            }

            const blacklistPath = './blacklist.txt';
            await fs.appendFile(blacklistPath, `${token}\n`);

            res.status(200).json({ success: true, message: 'Đăng xuất thành công' });
        } catch (error) {
            console.error('Lỗi trong /logout:', error);
            res.status(500).json({
                success: false,
                message: error.message || 'Lỗi server nội bộ',
            });
        }
    }

    static async checkBlacklist(req, res, next) {
        try {
            const token = req.headers.authorization?.split(' ')[1];
            if (!token) {
                return res.status(400).json({ success: false, message: 'Không có token được cung cấp' });
            }

            const blacklistPath = './blacklist.txt';
            const blacklist = await fs.readFile(blacklistPath, 'utf-8');
            const blacklistedTokens = blacklist.split('\n').filter(t => t.trim() !== '');

            if (blacklistedTokens.includes(token)) {
                return res.status(401).json({ success: false, message: 'Token đã bị đưa vào danh sách đen' });
            }

            const decoded = jwt.verify(token, config.JWT_SECRET);
            req.user = decoded;
            next();
        } catch (error) {
            console.error('Lỗi trong checkBlacklist:', error);
            res.status(401).json({
                success: false,
                message: 'Token không hợp lệ',
            });
        }
    }

    static async completeOnboarding(req, res, next) {
        try {
            const token = req.headers.authorization?.split(' ')[1];
            if (!token) {
                return res.status(400).json({ success: false, message: 'Không có token được cung cấp' });
            }

            const decoded = jwt.verify(token, config.JWT_SECRET);
            const user = await UserModel.updateOnboardingStatus(decoded.email);

            if (!user) {
                return res.status(404).json({ success: false, message: 'Không tìm thấy người dùng' });
            }

            res.status(200).json({ success: true, message: 'Hoàn tất onboarding' });
        } catch (error) {
            console.error('Lỗi trong completeOnboarding:', error);
            res.status(500).json({
                success: false,
                message: error.message || 'Lỗi server nội bộ',
            });
        }
    }

    static async updateProfile(req, res, next) {
        try {
            const { gender, height, weight, age, goal, activityLevel, bmi } = req.body;

            // Kiểm tra ít nhất một trường phải được cung cấp
            if (!gender && !height && !weight && !age && !goal && !activityLevel && !bmi) {
                return res.status(400).json({ success: false, message: 'Cần cung cấp ít nhất một trường thông tin profile' });
            }

            // Tạo object chỉ chứa các trường được cung cấp
            const profileData = {};
            if (gender) profileData.gender = gender;
            if (height) profileData.height = height;
            if (weight) profileData.weight = weight;
            if (age) profileData.age = age;
            if (goal) profileData.goal = goal;
            if (activityLevel) profileData.activityLevel = activityLevel;
            if (bmi) profileData.bmi = bmi;

            const user = await UserModel.updateProfile(req.user.email, profileData);
            if (!user) {
                return res.status(404).json({ success: false, message: 'Không tìm thấy người dùng' });
            }

            res.status(200).json({
                success: true,
                data: { profile: user.profile },
                message: 'Cập nhật profile thành công',
            });
        } catch (error) {
            console.error('Lỗi trong updateProfile:', error);
            res.status(500).json({
                success: false,
                message: error.message || 'Lỗi server nội bộ',
            });
        }
    }
}

module.exports = AuthController;