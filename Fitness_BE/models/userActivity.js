// models/userActivity.js
const mongoose = require('mongoose');

const userActivitySchema = new mongoose.Schema({
    user_id: {
        type: mongoose.Schema.Types.ObjectId,
        ref: 'User',
        required: true,
    },
    activity_type: {
        type: String,
        required: true,
        enum: ['run'],
    },
    time_in_seconds: {
        type: Number,
        required: true,
    },
    distance_in_km: {
        type: Number,
        required: true,
    },
    activity_date: {
        type: Date,
        required: true,
    },
    created_at: {
        type: Date,
        default: Date.now,
    },
});

module.exports = mongoose.model('UserActivity', userActivitySchema);