import 'package:fitness_tracker/features/services/fitbot_assitance/chatServices.dart';
import 'package:fitness_tracker/features/services/fitbot_assitance/recommend_activityLevel.dart';
import 'package:fitness_tracker/screens/userProfile/profile_data.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart';
import 'dart:convert';

/// Model for cooking steps
class CookingStep {
  final int stepNumber;
  final String instruction;
  final String id;

  CookingStep({
    required this.stepNumber,
    required this.instruction,
    required this.id,
  });

  factory CookingStep.fromJson(Map<String, dynamic> json) {
    return CookingStep(
      stepNumber: json['step_number'] ?? 0,
      instruction: json['instruction'] ?? '',
      id: json['_id'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'step_number': stepNumber, 'instruction': instruction, '_id': id};
  }
}

/// Model for suggested food items
class FoodSuggestion {
  final String title;
  final String description;
  final String image;
  final String supportFor;
  final int calories;
  final double protein; // grams
  final double fat; // grams
  final double carbs; // grams
  final List<String> ingredients;
  final List<CookingStep> steps;
  final String mealType; // breakfast, lunch, dinner, snack
  final String difficultyLevel; // easy, medium, hard

  FoodSuggestion({
    required this.title,
    required this.description,
    required this.image,
    required this.supportFor,
    required this.calories,
    required this.protein,
    required this.fat,
    required this.carbs,
    required this.ingredients,
    required this.steps,
    required this.mealType,
    required this.difficultyLevel,
  });

  factory FoodSuggestion.fromJson(Map<String, dynamic> json) {
    return FoodSuggestion(
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      image: json['image'] ?? '',
      supportFor: json['support_for'] ?? '',
      calories: json['calories'] ?? 0,
      protein: (json['protein'] ?? 0.0).toDouble(),
      fat: (json['fat'] ?? 0.0).toDouble(),
      carbs: (json['carbs'] ?? 0.0).toDouble(),
      ingredients: List<String>.from(json['ingredients'] ?? []),
      steps:
          (json['steps'] as List<dynamic>? ?? [])
              .map((step) => CookingStep.fromJson(step))
              .toList(),
      mealType: json['mealType'] ?? 'breakfast',
      difficultyLevel: json['difficultyLevel'] ?? 'easy',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'image': image,
      'support_for': supportFor,
      'calories': calories,
      'protein': protein,
      'fat': fat,
      'carbs': carbs,
      'ingredients': ingredients,
      'steps': steps.map((step) => step.toJson()).toList(),
      'mealType': mealType,
      'difficultyLevel': difficultyLevel,
    };
  }
}

/// Model for daily food plan
class DailyFoodPlan {
  final List<FoodSuggestion> breakfast;
  final List<FoodSuggestion> lunch;
  final List<FoodSuggestion> dinner;
  final List<FoodSuggestion> snacks;
  final int totalCalories;
  final double totalProtein;
  final double totalFat;
  final double totalCarbs;

  DailyFoodPlan({
    required this.breakfast,
    required this.lunch,
    required this.dinner,
    required this.snacks,
    required this.totalCalories,
    required this.totalProtein,
    required this.totalFat,
    required this.totalCarbs,
  });

  factory DailyFoodPlan.fromJson(Map<String, dynamic> json) {
    return DailyFoodPlan(
      breakfast:
          (json['breakfast'] as List<dynamic>? ?? [])
              .map((item) => FoodSuggestion.fromJson(item))
              .toList(),
      lunch:
          (json['lunch'] as List<dynamic>? ?? [])
              .map((item) => FoodSuggestion.fromJson(item))
              .toList(),
      dinner:
          (json['dinner'] as List<dynamic>? ?? [])
              .map((item) => FoodSuggestion.fromJson(item))
              .toList(),
      snacks:
          (json['snacks'] as List<dynamic>? ?? [])
              .map((item) => FoodSuggestion.fromJson(item))
              .toList(),
      totalCalories: json['totalCalories'] ?? 0,
      totalProtein: (json['totalProtein'] ?? 0.0).toDouble(),
      totalFat: (json['totalFat'] ?? 0.0).toDouble(),
      totalCarbs: (json['totalCarbs'] ?? 0.0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'breakfast': breakfast.map((item) => item.toJson()).toList(),
      'lunch': lunch.map((item) => item.toJson()).toList(),
      'dinner': dinner.map((item) => item.toJson()).toList(),
      'snacks': snacks.map((item) => item.toJson()).toList(),
      'totalCalories': totalCalories,
      'totalProtein': totalProtein,
      'totalFat': totalFat,
      'totalCarbs': totalCarbs,
    };
  }
}

/// Function to build prompt for food suggestion
String buildFoodSuggestionPrompt({
  required double weight,
  required double height,
  required double bmi,
  required String goal,
  required int age,
  String? gender,
  String? activityLevel,
  List<String>? allergies,
  List<String>? preferences,
}) {
  final allergyInfo =
      allergies != null && allergies.isNotEmpty
          ? '\n- Allergies: ${allergies.join(", ")}'
          : '';
  final preferenceInfo =
      preferences != null && preferences.isNotEmpty
          ? '\n- Preferences: ${preferences.join(", ")}'
          : '';

  return '''
I am an Asian person (Vietnamese) with the following information:
- Age: $age
- Gender: ${gender ?? 'unspecified'}
- Weight: $weight kg
- Height: $height cm
- BMI: $bmi
- Goal: $goal
- Activity level: ${activityLevel ?? 'moderate'}$allergyInfo$preferenceInfo

Please suggest a complete daily nutrition menu suitable for Asian people (especially Vietnamese) including:

**Special requirements for Asian/Vietnamese people:**
- Prioritize traditional Asian dishes: pho, rice, noodles, banh mi, fish cakes, fresh spring rolls, etc.
- Use ingredients easily found in Vietnam: rice, noodles, water spinach, bok choy, pork, chicken, catfish, shrimp, etc.
- Suitable cooking methods: boiling, steaming, stir-frying, grilling (low oil)
- Taste: lightly salty, mildly spicy, with fresh vegetables
- Rice/noodle/pho portions suitable for Asian eating culture

**IMPORTANT FOR IMAGES:**
- Use REAL image URLs of the actual Vietnamese dishes
- For Phở: use real pho bowl images
- For Cơm: use real Vietnamese rice dish images  
- For Bún: use real Vietnamese noodle images
- For Vietnamese snacks: use real Vietnamese dessert images

**Return format (return only JSON, no additional explanation):**
{
  "breakfast": [
    {
      "title": "Vietnamese breakfast dish name",
      "description": "Detailed description of the dish and its nutritional benefits",
      "image": "REAL_VIETNAMESE_FOOD_IMAGE_URL_HERE",
      "support_for": "$goal",
      "calories": [calorie number],
      "protein": [protein grams],
      "fat": [fat grams],
      "carbs": [carbohydrate grams],
      "ingredients": ["ingredient 1", "ingredient 2", "ingredient 3"],
      "steps": [
        {
          "step_number": 1,
          "instruction": "Detailed cooking instruction step 1",
          "_id": "step_id_1"
        },
        {
          "step_number": 2,
          "instruction": "Detailed cooking instruction step 2",
          "_id": "step_id_2"
        },
        {
          "step_number": 3,
          "instruction": "Detailed cooking instruction step 3",
          "_id": "step_id_3"
        }
      ],
      "mealType": "breakfast",
      "difficultyLevel": "easy"
    }
  ],
  "lunch": [
    {
      "title": "Vietnamese lunch dish name",
      "description": "Detailed description of the dish and its nutritional benefits",
      "image": "REAL_VIETNAMESE_FOOD_IMAGE_URL_HERE",
      "support_for": "$goal",
      "calories": [calorie number],
      "protein": [protein grams],
      "fat": [fat grams],
      "carbs": [carbohydrate grams],
      "ingredients": ["ingredient 1", "ingredient 2", "ingredient 3"],
      "steps": [
        {
          "step_number": 1,
          "instruction": "Detailed cooking instruction step 1",
          "_id": "step_id_4"
        },
        {
          "step_number": 2,
          "instruction": "Detailed cooking instruction step 2",
          "_id": "step_id_5"
        }
      ],
      "mealType": "lunch",
      "difficultyLevel": "medium"
    }
  ],
  "dinner": [
    {
      "title": "Vietnamese dinner dish name",
      "description": "Detailed description of the dish and its nutritional benefits",
      "image": "REAL_VIETNAMESE_FOOD_IMAGE_URL_HERE",
      "support_for": "$goal",
      "calories": [calorie number],
      "protein": [protein grams],
      "fat": [fat grams],
      "carbs": [carbohydrate grams],
      "ingredients": ["ingredient 1", "ingredient 2", "ingredient 3"],
      "steps": [
        {
          "step_number": 1,
          "instruction": "Detailed cooking instruction step 1",
          "_id": "step_id_6"
        },
        {
          "step_number": 2,
          "instruction": "Detailed cooking instruction step 2",
          "_id": "step_id_7"
        }
      ],
      "mealType": "dinner",
      "difficultyLevel": "medium"
    }
  ],
  "snacks": [
    {
      "title": "Vietnamese snack name",
      "description": "Detailed description of the snack and its benefits",
      "image": "REAL_VIETNAMESE_FOOD_IMAGE_URL_HERE",
      "support_for": "$goal",
      "calories": [calorie number],
      "protein": [protein grams],
      "fat": [fat grams],
      "carbs": [carbohydrate grams],
      "ingredients": ["ingredient 1", "ingredient 2"],
      "steps": [
        {
          "step_number": 1,
          "instruction": "Simple preparation step 1",
          "_id": "step_id_8"
        },
        {
          "step_number": 2,
          "instruction": "Simple preparation step 2",
          "_id": "step_id_9"
        }
      ],
      "mealType": "snack",
      "difficultyLevel": "easy"
    }
  ],
  "totalCalories": [total daily calories],
  "totalProtein": [total protein],
  "totalFat": [total fat],
  "totalCarbs": [total carbs]
}

**Important notes:**
- Calculate calories based on BMI, goals and activity level
- USE ONLY REAL VIETNAMESE FOOD IMAGE URLs
- Steps must be detailed and easy to follow with proper numbering
- Each step must have a unique _id
- Description should explain why this dish supports the user's goal
- Ensure balanced nutrition according to user's goals
- Return only JSON, no explanatory text
''';
}

/// Function to parse AI response
DailyFoodPlan parseAIResponse(String response) {
  try {
    // Find and extract JSON from response
    final jsonMatch = RegExp(r'\{.*\}', dotAll: true).firstMatch(response);
    if (jsonMatch == null) {
      throw Exception('No JSON found in response');
    }

    final jsonString = jsonMatch.group(0)!;
    final jsonData = jsonDecode(jsonString);

    // Parse the response and ensure reliable images
    final plan = DailyFoodPlan.fromJson(jsonData);

    // Update images with reliable URLs
    final updatedBreakfast =
        plan.breakfast
            .map(
              (food) => FoodSuggestion(
                title: food.title,
                description: food.description,
                image: getReliableFoodImageUrl(food.title, food.mealType),
                supportFor: food.supportFor,
                calories: food.calories,
                protein: food.protein,
                fat: food.fat,
                carbs: food.carbs,
                ingredients: food.ingredients,
                steps: food.steps,
                mealType: food.mealType,
                difficultyLevel: food.difficultyLevel,
              ),
            )
            .toList();

    final updatedLunch =
        plan.lunch
            .map(
              (food) => FoodSuggestion(
                title: food.title,
                description: food.description,
                image: getReliableFoodImageUrl(food.title, food.mealType),
                supportFor: food.supportFor,
                calories: food.calories,
                protein: food.protein,
                fat: food.fat,
                carbs: food.carbs,
                ingredients: food.ingredients,
                steps: food.steps,
                mealType: food.mealType,
                difficultyLevel: food.difficultyLevel,
              ),
            )
            .toList();

    final updatedDinner =
        plan.dinner
            .map(
              (food) => FoodSuggestion(
                title: food.title,
                description: food.description,
                image: getReliableFoodImageUrl(food.title, food.mealType),
                supportFor: food.supportFor,
                calories: food.calories,
                protein: food.protein,
                fat: food.fat,
                carbs: food.carbs,
                ingredients: food.ingredients,
                steps: food.steps,
                mealType: food.mealType,
                difficultyLevel: food.difficultyLevel,
              ),
            )
            .toList();

    final updatedSnacks =
        plan.snacks
            .map(
              (food) => FoodSuggestion(
                title: food.title,
                description: food.description,
                image: getReliableFoodImageUrl(food.title, food.mealType),
                supportFor: food.supportFor,
                calories: food.calories,
                protein: food.protein,
                fat: food.fat,
                carbs: food.carbs,
                ingredients: food.ingredients,
                steps: food.steps,
                mealType: food.mealType,
                difficultyLevel: food.difficultyLevel,
              ),
            )
            .toList();

    return DailyFoodPlan(
      breakfast: updatedBreakfast,
      lunch: updatedLunch,
      dinner: updatedDinner,
      snacks: updatedSnacks,
      totalCalories: plan.totalCalories,
      totalProtein: plan.totalProtein,
      totalFat: plan.totalFat,
      totalCarbs: plan.totalCarbs,
    );
  } catch (e) {
    debugPrint('Error parsing AI response: $e');

    // Return default plan if parsing fails
    return _getDefaultFoodPlan();
  }
}

/// Function to get reliable food image URL
String getReliableFoodImageUrl(String foodName, String mealType) {
  // Map of reliable food images with stable URLs
  final Map<String, String> foodImages = {
    'pho':
        'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSsln1DDCYMtfnpPU-wGUii1rYP9XEjlJPNCw&s',
    'com_tam':
        'https://sunhouse.com.vn/pic/news/images/7-cach-nau-com-tam-bang-noi-com-dien.jpg',
    'bun_bo':
        'https://www.shutterstock.com/image-photo/hue-beef-noodle-authentic-traditional-600nw-2554158773.jpg',
    'banh_mi':
        'https://cdn.tgdd.vn/Files/2021/08/20/1376583/cach-lam-banh-mi-thit-nuong-cuc-don-gian-bang-chai-nhua-co-san-tai-nha-202108201640593483.jpg',
    'rice':
        'https://cdn.tgdd.vn/Files/2020/03/18/1246611/cach-nau-com-ngon-bang-noi-com-dien-don-gian-ma-hieu-qua-202003181444515871.jpg',
    'noodles':
        'https://www.allrecipes.com/thmb/K0rliBG9KK5j3TCNxZgF5XoAY-s=/1500x0/filters:no_upscale():max_bytes(150000):strip_icc()/270770-garlic-noodles-ddmfs-4x3-0189-95ad30c68efd42e592a70ec82d24f0b9.jpg',
    'soup':
        'https://images.getrecipekit.com/20241001155039-untitled-20-10.png?aspect_ratio=16:9&quality=90&',
    'vietnamese_food':
        'https://assets.vogue.com/photos/5a3aac8f0193fe386b1e3898/master/w_2560%2Cc_limit/vietnamese-food-holding.jpg',
    'spring_rolls':
        'https://www.maggi.co.uk/sites/default/files/srh_recipes/2058a74f39245e0065743463242b5f91.jpg',
    'fried_rice':
        'https://i.ytimg.com/vi/FR4DH5sSysI/maxresdefault.jpg',
    'default':
        'https://img.freepik.com/free-vector/food-cooking-graphic-illustration_53876-9120.jpg',
  };
  // Try to match food name with available images
  final lowerFoodName = foodName.toLowerCase();

  if (lowerFoodName.contains('phở') || lowerFoodName.contains('pho')) {
    return foodImages['pho']!;
  } else if (lowerFoodName.contains('cơm tấm') ||
      lowerFoodName.contains('com tam')) {
    return foodImages['com_tam']!;
  } else if (lowerFoodName.contains('bún bò') ||
      lowerFoodName.contains('bun bo')) {
    return foodImages['bun_bo']!;
  } else if (lowerFoodName.contains('bánh mì') ||
      lowerFoodName.contains('banh mi')) {
    return foodImages['banh_mi']!;
  } else if (lowerFoodName.contains('cơm') || lowerFoodName.contains('rice')) {
    return foodImages['rice']!;
  } else if (lowerFoodName.contains('bún') ||
      lowerFoodName.contains('noodle')) {
    return foodImages['noodles']!;
  } else if (lowerFoodName.contains('soup') || lowerFoodName.contains('canh')) {
    return foodImages['soup']!;
  } else if (lowerFoodName.contains('spring roll') ||
      lowerFoodName.contains('gỏi cuốn')) {
    return foodImages['spring_rolls']!;
  } else if (lowerFoodName.contains('fried rice') ||
      lowerFoodName.contains('cơm chiên')) {
    return foodImages['fried_rice']!;
  }

  return foodImages['default']!;
}

/// Fallback food plan when AI is not working
DailyFoodPlan _getDefaultFoodPlan() {
  return DailyFoodPlan(
    breakfast: [
      FoodSuggestion(
        title: 'Phở gà',
        description:
            'Traditional Vietnamese chicken noodle soup, rich in protein and low in fat. Perfect for weight management and muscle building with balanced carbohydrates from rice noodles.',
        image: getReliableFoodImageUrl('Phở gà', 'breakfast'),
        supportFor: 'Weight loss and muscle building',
        calories: 320,
        protein: 25.0,
        fat: 8.0,
        carbs: 35.0,
        ingredients: [
          'Rice noodles (100g)',
          'Chicken breast (150g)',
          'Green onions (20g)',
          'Cilantro (10g)',
          'Chicken broth (300ml)',
          'Fish sauce (1 tsp)',
          'Ginger (5g)',
        ],
        steps: [
          CookingStep(
            stepNumber: 1,
            instruction:
                'Boil chicken breast with ginger for 20 minutes until fully cooked, then remove and slice thinly.',
            id: 'pho_step_1',
          ),
          CookingStep(
            stepNumber: 2,
            instruction:
                'Soak rice noodles in hot water for 10 minutes until soft, then drain.',
            id: 'pho_step_2',
          ),
          CookingStep(
            stepNumber: 3,
            instruction:
                'Heat the chicken broth, season with fish sauce and a pinch of salt.',
            id: 'pho_step_3',
          ),
          CookingStep(
            stepNumber: 4,
            instruction:
                'Place noodles in bowl, add sliced chicken, pour hot broth over, garnish with green onions and cilantro.',
            id: 'pho_step_4',
          ),
        ],
        mealType: 'breakfast',
        difficultyLevel: 'medium',
      ),
    ],
    lunch: [
      FoodSuggestion(
        title: 'Cơm tấm sườn nướng',
        description:
            'Grilled pork ribs with broken rice, providing high protein for muscle building and energy for workouts. Served with fresh vegetables for balanced nutrition.',
        image: getReliableFoodImageUrl('Cơm tấm sườn nướng', 'lunch'),
        supportFor: 'Muscle building and weight management',
        calories: 450,
        protein: 35.0,
        fat: 12.0,
        carbs: 50.0,
        ingredients: [
          'Broken rice (150g)',
          'Pork ribs (200g)',
          'Pickled vegetables (50g)',
          'Fish sauce (1 tbsp)',
          'Lemongrass (1 stalk)',
          'Garlic (2 cloves)',
          'Egg (1 piece)',
        ],
        steps: [
          CookingStep(
            stepNumber: 1,
            instruction:
                'Marinate pork ribs with minced lemongrass, garlic, and fish sauce for 30 minutes.',
            id: 'com_tam_step_1',
          ),
          CookingStep(
            stepNumber: 2,
            instruction:
                'Grill ribs over medium heat for 15-20 minutes, turning occasionally until golden brown.',
            id: 'com_tam_step_2',
          ),
          CookingStep(
            stepNumber: 3,
            instruction:
                'Cook broken rice in rice cooker with 1:1.2 ratio of rice to water.',
            id: 'com_tam_step_3',
          ),
          CookingStep(
            stepNumber: 4,
            instruction:
                'Fry egg sunny-side up and serve rice with grilled ribs, fried egg, and pickled vegetables.',
            id: 'com_tam_step_4',
          ),
        ],
        mealType: 'lunch',
        difficultyLevel: 'easy',
      ),
    ],
    dinner: [
      FoodSuggestion(
        title: 'Bún bò Huế',
        description:
            'Spicy beef noodle soup from Hue, rich in protein and moderate in calories. The spices boost metabolism and the broth provides hydration and nutrients.',
        image: getReliableFoodImageUrl('Bún bò Huế', 'dinner'),
        supportFor: 'Weight loss and metabolism boost',
        calories: 380,
        protein: 28.0,
        fat: 15.0,
        carbs: 35.0,
        ingredients: [
          'Round rice noodles (100g)',
          'Beef shank (150g)',
          'Pork blood (50g)',
          'Lemongrass (2 stalks)',
          'Chili oil (1 tsp)',
          'Fresh herbs (mint, cilantro)',
          'Shrimp paste (1/2 tsp)',
        ],
        steps: [
          CookingStep(
            stepNumber: 1,
            instruction:
                'Boil beef shank with lemongrass for 1.5 hours until tender, then slice thinly.',
            id: 'bun_bo_step_1',
          ),
          CookingStep(
            stepNumber: 2,
            instruction:
                'Season the broth with shrimp paste, chili oil, and salt to taste.',
            id: 'bun_bo_step_2',
          ),
          CookingStep(
            stepNumber: 3,
            instruction:
                'Boil round noodles for 8-10 minutes until tender, then rinse with cold water.',
            id: 'bun_bo_step_3',
          ),
          CookingStep(
            stepNumber: 4,
            instruction:
                'Serve noodles in bowl with beef slices, pour hot broth over, garnish with fresh herbs and lime.',
            id: 'bun_bo_step_4',
          ),
        ],
        mealType: 'dinner',
        difficultyLevel: 'medium',
      ),
    ],
    snacks: [
      FoodSuggestion(
        title: 'Bánh mì thịt nướng',
        description:
            'Vietnamese grilled pork sandwich with fresh vegetables, providing lean protein and fiber. A healthy, portable snack option for active lifestyle.',
        image: getReliableFoodImageUrl('Bánh mì thịt nướng', 'snack'),
        supportFor: 'Healthy snacking and protein boost',
        calories: 150,
        protein: 6.0,
        fat: 2.0,
        carbs: 28.0,
        ingredients: [
          'Vietnamese baguette (1/2 piece)',
          'Grilled pork (50g)',
          'Pickled carrots (20g)',
          'Cilantro (5g)',
          'Cucumber (30g)',
        ],
        steps: [
          CookingStep(
            stepNumber: 1,
            instruction:
                'Grill marinated pork slices for 8-10 minutes until cooked through and slightly charred.',
            id: 'banh_mi_step_1',
          ),
          CookingStep(
            stepNumber: 2,
            instruction:
                'Cut baguette lengthwise, remove some of the bread inside to reduce calories.',
            id: 'banh_mi_step_2',
          ),
          CookingStep(
            stepNumber: 3,
            instruction:
                'Fill bread with grilled pork, pickled carrots, cucumber slices, and fresh cilantro.',
            id: 'banh_mi_step_3',
          ),
        ],
        mealType: 'snack',
        difficultyLevel: 'easy',
      ),
    ],
    totalCalories: 1300,
    totalProtein: 94.0,
    totalFat: 37.0,
    totalCarbs: 148.0,
  );
}

// Clear all food image caches to force reload with new URLs
Future<void> clearFoodImageCache() async {
  final prefs = await SharedPreferences.getInstance();
  final keys = prefs.getKeys().where((key) => key.startsWith('food_')).toList();

  for (final key in keys) {
    await prefs.remove(key);
  }

  debugPrint('Cleared ${keys.length} food cache entries');
}

// Get the recommend food daily suggestion from AI the food daily suggestion include image, name, calories, protein, fat, and got the step to do it
Future<DailyFoodPlan> getFoodDailySuggestion({
  required String userId,
  required double weight,
  required double height,
  required double bmi,
  required String goal,
  required int age,
  String? gender,
  String? activityLevel,
  List<String>? allergies,
  List<String>? preferences,
  ProfileData? userProfile,
}) async {
  final prefs = await SharedPreferences.getInstance();
  final today = getTodayKey();

  // Round numbers before building cache key
  final roundedWeight = roundDouble(weight, 1);
  final roundedHeight = roundDouble(height, 1);
  final roundedBmi = roundDouble(
    bmi,
    1,
  ); // Log profile info safely without sensitive data
  debugPrint('Food suggestion requested for user profile');

  final cacheKey = buildCacheKey(
    weight: roundedWeight,
    height: roundedHeight,
    bmi: roundedBmi,
    goal: goal,
    age: age,
    date: today,
  );

  // Check local cache (SharedPreferences)
  final cachedData = prefs.getString('food_$cacheKey');
  if (cachedData != null) {
    try {
      final cacheMap = jsonDecode(cachedData);
      final expire = cacheMap['expire'] as int?;
      final now = DateTime.now().millisecondsSinceEpoch;
      if (expire != null && expire > now) {
        // Not expired, return cache
        debugPrint('Food suggestion retrieved from cache');
        return DailyFoodPlan.fromJson(cacheMap['data']);
      } else {
        // Expired, remove old cache
        await prefs.remove('food_$cacheKey');
      }
    } catch (e) {
      debugPrint('Error parsing food cache: $e');
      await prefs.remove('food_$cacheKey');
    }
  }
  // If no cache or cache expired, call AI
  debugPrint('Calling AI food suggestion...');
  try {
    final chatService = ChatService(userId);
    final prompt = buildFoodSuggestionPrompt(
      weight: roundedWeight,
      height: roundedHeight,
      bmi: roundedBmi,
      goal: goal,
      age: age,
      gender: gender,
      activityLevel: activityLevel,
      allergies: allergies,
      preferences: preferences,
    );
    final response = await chatService.getFitnessResponse(
      prompt,
      shouldSaveLog: false,
      userProfile: userProfile,
    );

    debugPrint('AI food response received successfully');

    // Parse response
    final foodPlan = parseAIResponse(response);

    // Cache the result
    final cacheMap = {
      'expire': getExpireTimestamp(),
      'data': foodPlan.toJson(),
    };
    await prefs.setString('food_$cacheKey', jsonEncode(cacheMap));
    debugPrint(
      'AI food suggestion success: ${foodPlan.totalCalories} calories',
    );
    return foodPlan;
  } catch (e) {
    debugPrint('Error calling AI food suggestion: $e');
    // Return default plan if AI fails
    return _getDefaultFoodPlan();
  }
}

/// Test all food image URLs to ensure they work
Future<void> testFoodImageUrls() async {
  final Map<String, String> testUrls = {
    'Phở gà': getReliableFoodImageUrl('Phở gà', 'breakfast'),
    'Cơm tấm sườn nướng': getReliableFoodImageUrl(
      'Cơm tấm sườn nướng',
      'lunch',
    ),
    'Bún bò Huế': getReliableFoodImageUrl('Bún bò Huế', 'dinner'),
    'Bánh mì thịt nướng': getReliableFoodImageUrl(
      'Bánh mì thịt nướng',
      'snack',
    ),
    'Vietnamese food': getReliableFoodImageUrl('Vietnamese food', 'default'),
  };

  debugPrint('Testing food image URLs:');
  testUrls.forEach((food, url) {
    debugPrint('$food: $url');
  });
}
