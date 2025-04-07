import 'package:fitness_tracker/common/widgets/appbar/appbar.dart';
import 'package:fitness_tracker/features/services/getProfile.dart';
import 'package:fitness_tracker/screens/onboardingFeature/ageScreen/ageScreen.dart';
import 'package:fitness_tracker/userProfile/profile_data.dart';
import 'package:flutter/material.dart';
import 'package:fitness_tracker/utils/constants/colors.dart';
import 'package:iconsax/iconsax.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      // backgroundColor: Colors.white,
      appBar: const TAppBar(
        title: Text('Body Index'),
        centerTitle: true,
        showBackButton: true,
        color: Colors.black,
      ),
      body: FutureBuilder<ProfileData?>(
        future: ApiService.fetchProfileData(),
        builder: (context, snapshot) {
          return Stack(
            children: [
              SingleChildScrollView(
                padding: const EdgeInsets.only(bottom: 100),
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    children: [
                      // Avatar
                      Container(
                        width: 140,
                        height: 140,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: TColors.primary,
                        ),
                        child:
                            snapshot.data?.profileImage != null
                                ? ClipOval(
                                  child: Image.network(
                                    snapshot.data!.profileImage!,
                                    fit: BoxFit.cover,
                                  ),
                                )
                                : const Icon(
                                  Icons.person,
                                  color: Colors.white,
                                  size: 70,
                                ),
                      ),
                      const SizedBox(height: 24),

                      // Name
                      Text(
                        snapshot.data?.username ?? 'No Name',
                        style: textTheme.headlineMedium!.copyWith(
                          color: const Color(0xFF1B1B1B),
                          fontWeight: FontWeight.w600,
                          fontSize: 28,
                        ),
                      ),
                      const SizedBox(height: 8),

                      // Email
                      Text(
                        snapshot.data?.email ?? 'No Email',
                        style: textTheme.bodyLarge!.copyWith(
                          color: const Color(0xFF6B7280),
                        ),
                      ),
                      const SizedBox(height: 40),

                      // Info Grid
                      GridView.count(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        crossAxisCount: 2,
                        mainAxisSpacing: 16,
                        crossAxisSpacing: 16,
                        childAspectRatio: 1,
                        children: [
                          _buildInfoCard(
                            context,
                            'Height',
                            'assets/icons/height.png',
                            '${snapshot.data?.height ?? 0} cm',
                          ),
                          _buildInfoCard(
                            context,
                            'Weight',
                            'assets/icons/weight.png',
                            '${snapshot.data?.weight ?? 0} kg',
                          ),
                          _buildInfoCard(
                            context,
                            'Goal',
                            'assets/icons/goal.png',
                            _formatGoal(snapshot.data?.goal),
                          ),
                          _buildInfoCard(
                            context,
                            'Activity level',
                            'assets/icons/activity.png',
                            _formatActivityLevel(snapshot.data?.activityLevel),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              // Update Profile Button
              Positioned(
                left: 24,
                right: 24,
                bottom: 24,
                child: SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const AgePage(),
                        ),
                      );
                    },
                    child: const Text('Update profile'),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  String _formatGoal(String? goal) {
    if (goal == null || goal.isEmpty) return 'Not set';
    return goal
        .split('_')
        .map(
          (word) =>
              word.isNotEmpty
                  ? '${word[0].toUpperCase()}${word.substring(1).toLowerCase()}'
                  : '',
        )
        .join(' ');
  }

  String _formatActivityLevel(String? level) {
    if (level == null || level.isEmpty) return 'Not set';
    return '${level[0].toUpperCase()}${level.substring(1).toLowerCase()}';
  }

  Widget _buildInfoCard(
    BuildContext context,
    String label,
    String iconPath,
    String value,
  ) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: TColors.black, width: 1),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: TColors.primary.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Center(child: _getIconForLabel(label)),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: TColors.black.withOpacity(0.7),
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          // const SizedBox(height: 8),
          Text(
            value,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: TColors.black,
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _getIconForLabel(String label) {
    const iconColor = TColors.black;
    const iconSize = 28.0;

    switch (label.toLowerCase()) {
      case 'height':
        return const Icon(Iconsax.ruler, color: iconColor, size: iconSize);
      case 'weight':
        return const Icon(Iconsax.weight_1, color: iconColor, size: iconSize);
      case 'goal':
        return const Icon(
          Iconsax.clipboard_tick,
          color: iconColor,
          size: iconSize,
        );
      case 'activity level':
        return const Icon(Iconsax.chart_2, color: iconColor, size: iconSize);
      default:
        return const Icon(Iconsax.user, color: iconColor, size: iconSize);
    }
  }
}
