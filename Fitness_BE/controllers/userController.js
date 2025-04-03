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
                    profileImage: user.profileImage,

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
    static async updateProfile(req, res, next) {
        try {
            const { gender, height, weight, age, goal, activityLevel, bmi, userName, profileImage, email } = req.body;

            // Kiểm tra ít nhất một trường phải được cung cấp
            if (!gender && !height && !weight && !age && !goal && !activityLevel && !bmi && !userName && !profileImage && !email) {
                return res.status(400).json({ success: false, message: 'Please provide at least one profile information field' });
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
            if (userName) profileData.userName = userName;
            if (email) profileData.email = email;
            if (profileImage) profileData.profileImage = profileImage;

            const user = await UserModel.updateProfile(req.user.email, profileData);
            if (!user) {
                return res.status(404).json({ success: false, message: 'User not found' });
            }

            res.status(200).json({
                success: true,
                data: { 
                    profile: user.profile, 
                    userName: user.userName, 
                    email: user.email,
                    profileImage: user.profileImage 
                },
                message: 'Update profile successfully',
            });
        } catch (error) {
            console.error('Error in updateProfile:', error);
            res.status(500).json({
                success: false,
                message: error.message || 'Internal server error',
            });
        }
    }
    static async uploadProfileImage(req, res, next) {
        try {
            if (!req.file) {
                return res.status(400).json({
                    success: false,
                    message: 'No image file uploaded'
                });
            }

            // Tạo URL cho ảnh đã upload
            const imageUrl = `${req.protocol}://${req.get('host')}/uploads/${req.file.filename}`;

            // Cập nhật profileImage trong database
            const user = await UserModel.updateProfile(req.user.email, {
                profileImage: imageUrl
            });

            if (!user) {
                return res.status(404).json({
                    success: false,
                    message: 'User not found'
                });
            }

            res.status(200).json({
                success: true,
                data: {
                    profileImage: imageUrl
                },
                message: 'Profile image uploaded successfully'
            });
        } catch (error) {
            console.error('Error in uploadProfileImage:', error);
            res.status(500).json({
                success: false,
                message: error.message || 'Internal server error'
            });
        }
    }
}

module.exports = UserProfile;