import 'dart:convert';
import 'package:fitness_tracker/features/services/home_services/recent_plan/get_recent_plan.dart';
import 'package:fitness_tracker/screens/home/widgets/suggest_food/detail_suggest.dart';
import 'package:fitness_tracker/utils/constants/colors.dart';
import 'package:fitness_tracker/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fitness_tracker/screens/userProfile/profile_data.dart';

class RecentPlans extends StatefulWidget {
  const RecentPlans({super.key});

  @override
  _RecentPlansState createState() => _RecentPlansState();
}

class _RecentPlansState extends State<RecentPlans>
    with SingleTickerProviderStateMixin {
  final RecentPlanService _recentPlanService = Get.find<RecentPlanService>();
  List<SuggestFood> _suggestedFoods = [];
  bool _isLoading = true;
  String? _errorMessage;
  String? _userGoal;
  late AnimationController _controller;
  late Animation<double> _opacityAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _opacityAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.2),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _loadUserProfile();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _loadUserProfile() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('jwt_token');

      if (token == null || token.isEmpty) {
        setState(() {
          _isLoading = false;
          _errorMessage = 'Please login to see suggestions';
        });
        return;
      }

      final profileJson = prefs.getString('userProfile');

      if (profileJson != null && profileJson.isNotEmpty) {
        final decodedJson = jsonDecode(profileJson);

        if (decodedJson is Map<String, dynamic>) {
          final profileData = ProfileData.fromJson(decodedJson);

          setState(() {
            _userGoal = profileData.goal;
          });

          if (_userGoal != null && _userGoal!.isNotEmpty) {
            await _loadSuggestFoods();
          } else {
            setState(() {
              _isLoading = false;
              _errorMessage = 'Please set a goal in your profile';
            });
          }
        } else {
          setState(() {
            _isLoading = false;
            _errorMessage = 'Invalid profile data';
          });
        }
      } else {
        setState(() {
          _isLoading = false;
          _errorMessage = 'Profile not found';
        });
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Error loading profile: $e';
      });
    }
  }

  Future<void> _loadSuggestFoods() async {
    try {
      if (_userGoal == null) {
        setState(() {
          _isLoading = false;
          _errorMessage = 'Please set a goal in your profile';
        });
        return;
      }

      final foods = await _recentPlanService.getSuggestFoodByGoal(_userGoal!);

      if (foods.isEmpty) {
        setState(() {
          _isLoading = false;
          _errorMessage = 'No suggestions available for your goal';
        });
      } else {
        setState(() {
          _suggestedFoods = foods.take(4).toList();
          _isLoading = false;
          _errorMessage = null;
        });
        _controller.forward();
      }
    } catch (e) {
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
          _isLoading
              ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 180,
                    height: 30,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF5F9FF),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  const SizedBox(height: TSizes.spaceBtwItems),
                  Container(
                    width: 250,
                    height: 20,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF5F9FF),
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  const SizedBox(height: TSizes.spaceBtwItems),
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    padding: const EdgeInsets.all(20.0),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF5F9FF),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    height: 120,
                    width: double.infinity,
                  ),
                ],
              )
              : Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'What you eat today?',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: TSizes.spaceBtwItems),
                  Text(
                    'Here is some suggest for your goal',
                    style: Theme.of(
                      context,
                    ).textTheme.bodySmall?.copyWith(color: Colors.grey),
                  ),
                  const SizedBox(height: TSizes.spaceBtwItems),
                  if (_errorMessage != null)
                    Center(
                      child: Text(
                        _errorMessage!,
                        style: const TextStyle(color: Colors.red, fontSize: 16),
                      ),
                    )
                  else if (_suggestedFoods.isEmpty)
                    const Center(
                      child: Text(
                        'No suggestions available.',
                        style: TextStyle(fontSize: 16),
                      ),
                    )
                  else
                    FadeTransition(
                      opacity: _opacityAnimation,
                      child: SlideTransition(
                        position: _slideAnimation,
                        child: Row(
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
                                                (context) => DetailSuggest(
                                                  suggestFood: food,
                                                ),
                                          ),
                                        );
                                      },
                                      color: TColors.primary,
                                    ),
                                  )
                                  .toList(),
                        ),
                      ),
                    ),
                ],
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
