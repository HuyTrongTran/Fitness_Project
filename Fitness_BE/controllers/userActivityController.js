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
        const user_id = req.user.id;

        const { time_in_seconds, distance_in_km, route_points, activity_date, steps, calories } = req.body;

        // Kiểm tra dữ liệu đầu vào
        if (!time_in_seconds || !distance_in_km) {
            return res.status(400).json({ error: 'Missing required fields' });
        }

        // Kiểm tra time_in_seconds và distance_in_km phải là số dương
        if (time_in_seconds <= 0 || distance_in_km <= 0) {
            return res.status(400).json({ error: 'Time and distance must be positive numbers' });
        }

        // Kiểm tra xem user có tồn tại không
        const user = await User.findById(user_id);
        if (!user) {
            return res.status(404).json({ success: false, message: 'User not found' });
        }

        // Tạo một document UserActivity mới
        const newActivity = new UserActivity({
            user_id,
            activity_type: 'run',
            time_in_seconds,
            distance_in_km,
            activity_date: activity_date || new Date().toISOString().split('T')[0],
            route_points: route_points || [],
            steps: steps || Math.floor(distance_in_km * 1250), // Sử dụng steps từ request hoặc tính toán
            calories: calories || distance_in_km * 60, // Sử dụng calories từ request hoặc tính toán
        });

        // Lưu activity vào collection user_activity
        const savedActivity = await newActivity.save();

        // Cập nhật mảng profile.activities của user
        await UserModel.updateProfile(user.email, {
            activities: [...(user.profile.activities || []), savedActivity._id],
        });

        // Trả về kết quả
        res.status(201).json({
            message: 'Saved your session successfully',
            data: savedActivity,
        });
    } catch (error) {
        console.error('Error submitting run session:', error);
        res.status(500).json({ error: 'Internal server error', details: error.message });
    }
};

const getRunHistory = async (req, res) => {
    try {
        const user_id = req.user.id;
        const { startDate, endDate } = req.query;

        // Tạo điều kiện tìm kiếm
        let query = {
            user_id,
            activity_type: 'run'
        };

        // Nếu có startDate và endDate thì thêm vào query
        if (startDate && endDate) {
            query.activity_date = {
                $gte: new Date(startDate),
                $lte: new Date(endDate)
            };
        }

        // Lấy danh sách hoạt động chạy bộ
        const activities = await UserActivity.find(query)
            .sort({ activity_date: -1 }); // Sắp xếp theo ngày mới nhất

        // Format lại dữ liệu trước khi trả về
        const formattedActivities = activities.map(activity => ({
            id: activity._id,
            date: activity.activity_date,
            time_in_seconds: activity.time_in_seconds,
            distance_in_km: activity.distance_in_km,
            calories: activity.calories,
            steps: activity.steps,
            route_points: activity.route_points || []
        }));

        res.status(200).json({
            success: true,
            data: formattedActivities
        });

    } catch (error) {
        console.error('Error fetching run history:', error);
        res.status(500).json({ error: 'Internal server error' });
    }
};

module.exports = { submitRunSession, getRunHistory };