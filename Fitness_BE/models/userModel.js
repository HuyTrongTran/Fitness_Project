const mongoose = require('mongoose');
const bcrypt = require('bcrypt');
const config = require('../config/config');

// Định nghĩa schema cho user
const userSchema = new mongoose.Schema({
  email: {
    type: String,
    required: true,
    unique: true,
    lowercase: true
  },
  password: {
    type: String,
    required: true
  },
  profile: {
    height: { type: Number, required: true },
    weight: { type: Number, required: true },
    goal: { 
      type: String, 
      enum: ['weight_loss', 'muscle_gain', 'maintenance'],
      required: true 
    },
    activityLevel: { 
      type: String,
      enum: ['sedentary', 'light', 'moderate', 'active', 'very_active'],
      required: true 
    },
    age: { type: Number, required: true }
  }
}, { collection: 'user_infor' }); // Chỉ định collection là 'user_infor'

// Hash mật khẩu trước khi lưu
userSchema.pre('save', async function(next) {
  if (this.isModified('password')) {
    this.password = await bcrypt.hash(this.password, config.SALT_ROUNDS);
  }
  next();
});

// Tạo model từ schema
const User = mongoose.model('User', userSchema);

// Phương thức tạo user mới
class UserModel {
  static async createUser(userData) {
    const user = new User(userData); // Tạo document mới từ dữ liệu gửi lên
    return await user.save(); // Lưu vào database, collection 'user_infor'
  }

  static async findByEmail(email) {
    return await User.findOne({ email });
  }

  static async verifyPassword(password, hashedPassword) {
    return await bcrypt.compare(password, hashedPassword);
  }
}

module.exports = UserModel;