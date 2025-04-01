// controllers/UserProfile.js
const { UserModel } = require('../models/userModel');
const config = require('../config/config');

// Debug: Log để kiểm tra UserModel
console.log('UserModel in UserProfile:', UserModel);

class UserProfile {
    static async getProfile(req, res, next) {
        try {
            // Kiểm tra xem UserModel có được import đúng không
            if (!UserModel) {
                throw new Error('UserModel is undefined. Check the import from userModel.js');
            }

            // Kiểm tra xem req.user có tồn tại không
            if (!req.user || !req.user.email) {
                return res.status(401).json({
                    success: false,
                    message: 'User authentication failed. Please check your token.',
                });
            }

            console.log('Get Profile:', req.user.email);
            const user = await UserModel.findByEmail(req.user.email);
            if (!user) {
                console.log('User not found with email:', req.user.email);
                return res.status(404).json({ success: false, message: 'User not found' });
            }

            console.log('User found:', user.email);
            res.status(200).json({
                success: true,
                data: {
                    profile: user.profile || {} ,
                    username: user.userName,
                    email: user.email,
                },
            });
        } catch (error) {
            console.error('Failed to getProfile:', error);
            res.status(500).json({
                success: false,
                message: error.message || 'Internal server error',
            });
        }
    }
}

module.exports = UserProfile;