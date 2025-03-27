// controllers/userActivityController.js
const { User, UserModel } = require('../models/userModel');
const UserActivity = require('../models/userActivity');

// Debug: Log để kiểm tra User và UserModel
console.log('User model:', User);
console.log('UserModel:', UserModel);

const submitRunSession = async (req, res, next) => {
    try {
        // Kiểm tra xem User có được import đúng không
        if (!User) {
            throw new Error('User model is undefined. Check the import from userModel.js');
        }

        // Lấy user_id từ token (được set bởi middleware checkBlacklist)
        const user_id = req.user.id; // Sử dụng req.user.id thay vì req.user._id vì token có id

        const { time_in_seconds, distance_in_km } = req.body;

        // Kiểm tra dữ liệu đầu vào
        if (!time_in_seconds || !distance_in_km) {
            return res.status(400).json({ error: 'Thiếu các trường bắt buộc: time_in_seconds, distance_in_km' });
        }

        // Kiểm tra time_in_seconds và distance_in_km phải là số dương
        if (time_in_seconds <= 0 || distance_in_km <= 0) {
            return res.status(400).json({ error: 'time_in_seconds và distance_in_km phải là số dương' });
        }

        // Kiểm tra xem user có tồn tại không
        const user = await User.findById(user_id);
        if (!user) {
            return res.status(404).json({ success: false, message: 'Không tìm thấy người dùng' });
        }

        // Lấy ngày hiện tại (định dạng YYYY-MM-DD)
        const currentDate = new Date().toISOString().split('T')[0];

        // Tạo một document UserActivity mới
        const newActivity = new UserActivity({
            user_id,
            activity_type: 'run',
            time_in_seconds,
            distance_in_km,
            activity_date: currentDate,
        });

        // Lưu activity vào collection user_activity
        const savedActivity = await newActivity.save();

        // Cập nhật mảng profile.activities của user
        await UserModel.updateProfile(user.email, {
            activities: [...(user.profile.activities || []), savedActivity._id],
        });

        // Trả về kết quả
        res.status(201).json({
            message: 'Gửi hoạt động chạy bộ thành công',
            data: savedActivity,
        });
    } catch (error) {
        console.error('Lỗi khi gửi hoạt động chạy bộ:', error);
        res.status(500).json({ error: 'Lỗi server nội bộ' });
    }
};

module.exports = { submitRunSession };