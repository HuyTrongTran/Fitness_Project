// controllers/getActivityCalendar.js
const { User, UserModel } = require('../models/userModel');
const UserActivity = require('../models/userActivity');

// Debug: Log để kiểm tra User và UserModel
console.log('User model in getActivityCalendar:', User);
console.log('UserModel in getActivityCalendar:', UserModel);

class GetActivityCalendar {
    static async getActivityData(req, res, next) {
        try {
            // Kiểm tra xem UserModel có được import đúng không
            if (!UserModel) {
                throw new Error('UserModel is undefined. Check the import from userModel.js');
            }

            // Lấy email từ token (được set bởi middleware checkBlacklist)
            const email = req.user.email;
            const { date } = req.query;

            // Kiểm tra định dạng ngày (YYYY-MM-DD)
            const dateRegex = /^\d{4}-\d{2}-\d{2}$/;
            const selectedDate = date && dateRegex.test(date) ? date : new Date().toISOString().split('T')[0];

            // Tìm user theo email
            const user = await UserModel.findByEmail(email);
            if (!user) {
                return res.status(404).json({ success: false, message: 'User not found' });
            }

            // Tìm các hoạt động của user cho ngày được chọn
            const startOfDay = new Date(selectedDate);
            startOfDay.setHours(0, 0, 0, 0);
            const endOfDay = new Date(selectedDate);
            endOfDay.setHours(23, 59, 59, 999);

            const activities = await UserActivity.find({
                user_id: user._id,
                activity_date: {
                    $gte: startOfDay,
                    $lte: endOfDay,
                },
            });

            // Nếu không có hoạt động, trả về "Rest Day"
            if (!activities || activities.length === 0) {
                return res.status(200).json({
                    success: true,
                    data: {
                        date: selectedDate.split('-').reverse().join('/'),
                        type: 'Rest Day',
                        workoutNumber: 0,
                        totalWorkouts: 0,
                        nextExercise: 'None',
                    },
                });
            }

            // Tính toán thông tin hoạt động
            const workoutPlan = {
                date: selectedDate.split('-').reverse().join('/'),
                type: activities[0].activity_type.charAt(0).toUpperCase() + activities[0].activity_type.slice(1), // Ví dụ: "Run"
                workoutNumber: activities.length, // Số lượng hoạt động trong ngày
                totalWorkouts: user.profile.activities.length, // Tổng số hoạt động của user
                nextExercise: activities[0].activity_type === 'run' ? 'Run' : 'None', // Có thể mở rộng logic cho các loại hoạt động khác
            };

            res.status(200).json({
                success: true,
                data: workoutPlan,
            });
        } catch (error) {
            console.error('Error when get activity data:', error);
            res.status(500).json({
                success: false,
                message: error.message || 'Internal server error!',
            });
        }
    }
}

module.exports = GetActivityCalendar;