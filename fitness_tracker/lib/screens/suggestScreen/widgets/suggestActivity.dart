import 'package:fitness_tracker/features/services/home_services/prefer_target.dart';
import 'package:fitness_tracker/features/services/user_profile_services/getProfile.dart';
import 'package:fitness_tracker/screens/userProfile/profile_data.dart';
import 'package:fitness_tracker/utils/constants/colors.dart';
import 'package:fitness_tracker/utils/constants/image_strings.dart';
import 'package:flutter/material.dart';

class SuggestActivityGrid extends StatefulWidget {
  const SuggestActivityGrid({super.key});

  @override
  State<SuggestActivityGrid> createState() => _SuggestActivityGridState();
}

class _SuggestActivityGridState extends State<SuggestActivityGrid>
    with SingleTickerProviderStateMixin {
  ActivityTarget? _activityTarget;
  bool _isLoading = true;
  String _errorMessage = '';
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
    _loadActivityData();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _loadActivityData() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      final profileData = await GetProfileService.fetchProfileData();
      final userProfile =
          profileData ??
          ProfileData(
            weight: 60.0,
            height: 170.0,
            age: 30,
            gender: 'male',
            activityLevel: 'moderate',
            goal: 'maintain',
          );
      final targetData = await ActivityTarget.getRecommendedTarget(userProfile);

      setState(() {
        _activityTarget = targetData;
        _isLoading = false;
      });
      _controller.forward();
    } catch (e) {
      setState(() {
        _errorMessage = 'Unable to load data: $e';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFF92A3FD).withOpacity(0.2),
            const Color(0xFF9DCEFF).withOpacity(0.2),
          ],
          begin: Alignment.topLeft * 4,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(28),
      ),
      child:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : FadeTransition(
                opacity: _opacityAnimation,
                child: SlideTransition(
                  position: _slideAnimation,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Suggest activity',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: TColors.black,
                        ),
                      ),
                      GridView.count(
                        crossAxisCount: 2,
                        shrinkWrap: true,
                        mainAxisSpacing: 16,
                        crossAxisSpacing: 16,
                        physics: const NeverScrollableScrollPhysics(),
                        childAspectRatio: 1.9,
                        children: [
                          _SuggestCard(
                            icon: Images.runIcon,
                            value: '${_activityTarget?.targetDistance} km',
                            label: 'Running',
                            valueColor: Color(0xFF4A90E2),
                          ),
                          _SuggestCard(
                            icon: Images.stepsIcon,
                            value: '${_activityTarget?.targetSteps}',
                            label: 'Foot Steps',
                            valueColor: Color(0xFFF5A623),
                          ),
                          _SuggestCard(
                            icon: Images.caloriesIcon,
                            value: '${_activityTarget?.targetCalories}',
                            label: 'Calories',
                            valueColor: Color(0xFF7ED957),
                          ),
                          _SuggestCard(
                            icon: Images.waterIcon,
                            value: '${_activityTarget?.targetWater}',
                            label: 'Water Intake',
                            valueColor: Color(0xFF4A90E2),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
    );
  }
}

class _SuggestCard extends StatelessWidget {
  final String icon;
  final String value;
  final String label;
  final Color valueColor;

  const _SuggestCard({
    required this.icon,
    required this.value,
    required this.label,
    required this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      child: Row(
        children: [
          Image.asset(icon, width: 36, height: 36),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  value,
                  style: TextStyle(
                    color: valueColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                Text(
                  label,
                  style: TextStyle(color: Colors.black54, fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
