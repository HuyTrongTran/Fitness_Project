const { SuggestFood, SuggestFoodModel } = require('../models/suggestFood');
const { uploadImageToStorage } = require('../utils/firebaseStorage');

class SuggestFoodController {
  // Tạo một suggest food mới
  static async createSuggestFood(req, res) {
    try {
      const { support_for, title, description, steps } = req.body;
      
      if (!req.file) {
        return res.status(400).json({
          success: false,
          message: 'Please provide an image'
        });
      }

      // Upload image to Firebase Storage
      const imageUrl = await uploadImageToStorage(req.file);
      
      try {
        const suggestFood = await SuggestFoodModel.createSuggestFood({
          support_for,
          image: imageUrl,
          title,
          description,
          steps: steps ? JSON.parse(steps) : []
        });

        res.status(201).json({
          success: true,
          data: {
            suggestFood
          },
          message: 'Suggest food created successfully'
        });
      } catch (error) {
        console.error('Error creating suggest food:', error);
        res.status(400).json({
          success: false,
          message: error.message || 'Error creating suggest food'
        });
      }
    } catch (error) {
      console.error('Error in createSuggestFood:', error);
      res.status(500).json({
        success: false,
        message: error.message || 'Internal server error'
      });
    }
  }

  // Lấy suggest foods theo loại hỗ trợ
  static async getSuggestFoodsBySupport(req, res) {
    try {
      const { support_for } = req.params;
      
      if (!support_for) {
        return res.status(400).json({
          success: false,
          message: 'Support type is required'
        });
      }
      
      const suggestFoods = await SuggestFoodModel.findBySupport(support_for);
      
      res.status(200).json({
        success: true,
        results: suggestFoods.length,
        data: {
          suggestFoods
        }
      });
    } catch (error) {
      console.error('Error in getSuggestFoodsBySupport:', error);
      res.status(500).json({
        success: false,
        message: error.message || 'Internal server error'
      });
    }
  }
}

module.exports = SuggestFoodController; 