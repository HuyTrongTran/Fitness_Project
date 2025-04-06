const express = require('express');
const router = express.Router();
const SuggestFoodController = require('../controllers/suggestFoodController');
const { protect, restrictTo } = require('../middleware/authMiddleware');
const upload = require('../utils/multerConfig');

router
    .route('/')
    .get(SuggestFoodController.getAllSuggestFoods)
    .post(
        protect,
        restrictTo('admin'),
        upload.single('image'),
        SuggestFoodController.createSuggestFood
    );

router
    .route('/:id')
    .get(SuggestFoodController.getSuggestFood)
    .patch(
        protect,
        restrictTo('admin'),
        upload.single('image'),
        SuggestFoodController.updateSuggestFood
    )
    .delete(
        protect,
        restrictTo('admin'),
        SuggestFoodController.deleteSuggestFood
    );

router
    .route('/support/:support_for')
    .get(SuggestFoodController.getSuggestFoodsBySupport);

module.exports = router; 