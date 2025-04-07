import 'dart:convert';
import 'package:fitness_tracker/features/services/home_service/recent_plan/get_recent_plan.dart';
import 'package:fitness_tracker/features/services/getProfile.dart';
import 'package:fitness_tracker/screens/activitiesScreen/activitiesScreen.dart';
import 'package:fitness_tracker/screens/home/widgets/suggest_food/detail_suggest.dart';
import 'package:fitness_tracker/utils/constants/colors.dart';
import 'package:fitness_tracker/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fitness_tracker/userProfile/profile_data.dart';

class RecentPlans extends StatefulWidget {
  const RecentPlans({super.key});

  @override
  _RecentPlansState createState() => _RecentPlansState();
}

class _RecentPlansState extends State<RecentPlans> {
  final RecentPlanService _recentPlanService = Get.find<RecentPlanService>();
  List<SuggestFood> _suggestedFoods = [];
  bool _isLoading = true;
  String? _errorMessage;
  String? _userGoal;

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  Future<void> _loadUserProfile() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('jwt_token');
      print('Loading user profile with token: $token');

      if (token == null || token.isEmpty) {
        print('No token found, user needs to login');
        setState(() {
          _isLoading = false;
          _errorMessage = 'Please login to see suggestions';
        });
        return;
      }

      final profileJson = prefs.getString('userProfile');
      print('Profile JSON from SharedPreferences: $profileJson');

      if (profileJson != null && profileJson.isNotEmpty) {
        final decodedJson = jsonDecode(profileJson);
        print('Decoded profile JSON: $decodedJson');

        if (decodedJson is Map<String, dynamic>) {
          final profileData = ProfileData.fromJson(decodedJson);
          print('Parsed profile data - goal: ${profileData.goal}');

          setState(() {
            _userGoal = profileData.goal;
          });

          if (_userGoal != null && _userGoal!.isNotEmpty) {
            print('User goal is set: $_userGoal');
            await _loadSuggestFoods();
          } else {
            print('User goal is empty or null');
            setState(() {
              _isLoading = false;
              _errorMessage = 'Please set a goal in your profile';
            });
          }
        } else {
          print('Decoded JSON is not a Map');
          setState(() {
            _isLoading = false;
            _errorMessage = 'Invalid profile data';
          });
        }
      } else {
        print('No profile data found in SharedPreferences');
        setState(() {
          _isLoading = false;
          _errorMessage = 'Profile not found';
        });
      }
    } catch (e) {
      print('Error loading user profile: $e');
      setState(() {
        _isLoading = false;
        _errorMessage = 'Error loading profile: $e';
      });
    }
  }

  Future<void> _loadSuggestFoods() async {
    print('Loading suggest foods for goal: $_userGoal');
    try {
      if (_userGoal == null) {
        print('User goal is null in _loadSuggestFoods');
        setState(() {
          _isLoading = false;
          _errorMessage = 'Please set a goal in your profile';
        });
        return;
      }

      print('Calling API to fetch suggest foods for goal: $_userGoal');
      final foods = await _recentPlanService.getSuggestFoodByGoal(_userGoal!);
      print('API response received: ${foods.length} foods');

      if (foods.isEmpty) {
        print('No suggest foods found for goal: $_userGoal');
        setState(() {
          _isLoading = false;
          _errorMessage = 'No suggestions available for your goal';
        });
      } else {
        print('Found ${foods.length} suggest foods:');
        for (var food in foods) {
          print('- ${food.title} (${food.id})');
          print('  Description: ${food.description}');
          print('  Image: ${food.image}');
          print('  Steps: ${food.steps.length}');
        }

        setState(() {
          _suggestedFoods = foods.take(4).toList();
          _isLoading = false;
          _errorMessage = null;
        });
      }
    } catch (e) {
      print('Error loading suggest foods: $e');
      setState(() {
        _isLoading = false;
        _errorMessage = 'Error loading suggestions: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final DateTime date = DateTime.now();
    final String formattedDate = DateFormat('MMMM, yyyy').format(date);

    return Padding(
      padding: const EdgeInsets.all(TSizes.defaultSpace),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'What you eat today?',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const Activities()),
                  );
                },
                child: Text(
                  'See All',
                  style: Theme.of(
                    context,
                  ).textTheme.bodyLarge?.copyWith(color: TColors.primary),
                ),
              ),
            ],
          ),
          const SizedBox(height: TSizes.spaceBtwItems / 2),
          Text(
            formattedDate,
            style: Theme.of(
              context,
            ).textTheme.bodyLarge?.copyWith(color: Colors.grey),
          ),
          const SizedBox(height: TSizes.spaceBtwItems),
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : _errorMessage != null
              ? Center(
                child: Text(
                  _errorMessage!,
                  style: const TextStyle(color: Colors.red, fontSize: 16),
                ),
              )
              : _suggestedFoods.isEmpty
              ? const Center(
                child: Text(
                  'No suggestions available.',
                  style: TextStyle(fontSize: 16),
                ),
              )
              : Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children:
                    _suggestedFoods
                        .map(
                          (food) => _buildPlanItem(
                            context,
                            key: ValueKey(food.id),
                            imageUrl: food.image,
                            title: food.title,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (context) =>
                                          DetailSuggest(suggestFood: food),
                                ),
                              );
                            },
                            color: TColors.primary,
                          ),
                        )
                        .toList(),
              ),
        ],
      ),
    );
  }

  Widget _buildPlanItem(
    BuildContext context, {
    Key? key,
    required String? imageUrl,
    required String title,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      key: key,
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              shape: BoxShape.circle,
              border: Border.all(color: color, width: 2),
              boxShadow: [
                BoxShadow(
                  color: color.withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Center(
              child: ClipOval(
                child:
                    imageUrl != null && imageUrl.isNotEmpty
                        ? Image.network(
                          imageUrl,
                          fit: BoxFit.cover,
                          width: 60,
                          height: 60,
                          errorBuilder:
                              (context, error, stackTrace) =>
                                  const Icon(Icons.broken_image, size: 30),
                        )
                        : const Icon(Icons.image_not_supported, size: 30),
              ),
            ),
          ),
          const SizedBox(height: TSizes.spaceBtwItems / 2),
          SizedBox(
            width: 70,
            child: Text(
              title,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
