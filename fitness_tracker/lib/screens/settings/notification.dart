import 'package:fitness_tracker/common/widgets/appbar/appbar.dart';
import 'package:fitness_tracker/utils/constants/image_strings.dart';
import 'package:flutter/material.dart';
import 'package:fitness_tracker/common/widgets/notification/notification_widgets.dart';
import 'package:fitness_tracker/utils/constants/colors.dart';
import 'package:fitness_tracker/utils/constants/sizes.dart';
import 'package:iconsax/iconsax.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  int selectedTabIndex = 0;
  List<String> tabs = ['Workout', 'Promotion'];

  List<NotificationItem> workoutNotifications = [
    NotificationItem(
      id: '1',
      type: NotificationType.workout,
      title: 'It\'s time to build your body back',
      message:
          'We will do it with 12 steps in 20 minutes and we burn about 500 kcal.',
      time: DateTime.now().subtract(const Duration(minutes: 5)),
      isRead: false,
      icon: Iconsax.medal_star,
      color: TColors.primary,
      workoutImage: Images.body_back, // Example image for workout
    ),
    NotificationItem(
      id: '2',
      type: NotificationType.workout,
      title: 'It\'s time to build your bicep',
      message:
          'We will do it with 12 steps in 20 minutes and we burn about 500 kcal.',
      time: DateTime.now().subtract(const Duration(hours: 1)),
      isRead: false,
      icon: Iconsax.timer_1,
      color: TColors.primary,
      workoutImage: Images.bicep, // Example image for workout
    ),
    NotificationItem(
      id: '3',
      type: NotificationType.workout,
      title: 'It\'s time to build your body butt',
      message:
          'We will do it with 12 steps in 20 minutes and we burn about 500 kcal.',
      time: DateTime.now().subtract(const Duration(hours: 2)),
      isRead: true,
      icon: Iconsax.profile_add,
      color: TColors.info,
      workoutImage: Images.body_butt, // Example image for workout
    ),
  ];

  List<NotificationItem> promotionNotifications = [
    NotificationItem(
      id: '4',
      type: NotificationType.promotion,
      title: 'Special Offer - Premium Membership',
      message:
          'Get 50% off on your first month premium membership. Limited time offer!',
      time: DateTime.now().subtract(const Duration(hours: 3)),
      isRead: true,
      icon: Iconsax.gift,
      color: Colors.orange,
    ),
  ];

  List<NotificationItem> get currentNotifications =>
      selectedTabIndex == 0 ? workoutNotifications : promotionNotifications;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const TAppBar(
        title: Text("Notifications"),
        color: TColors.black,
        showBackButton: true,
        centerTitle: true,
      ),
      backgroundColor: Colors.white,
      body: Column(
        children: [
          const SizedBox(height: TSizes.sm),
          // Tab Switcher
          NotificationTabSwitcher(
            selectedIndex: selectedTabIndex,
            onTabChanged: (index) {
              setState(() {
                selectedTabIndex = index;
              });
            },
            tabs: tabs,
          ),

          // Notifications List
          Expanded(
            child:
                currentNotifications.isEmpty
                    ? _buildEmptyState()
                    : ListView.separated(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      itemCount: currentNotifications.length,
                      separatorBuilder:
                          (context, index) => const SizedBox(height: 2),
                      itemBuilder: (context, index) {
                        final notification = currentNotifications[index];
                        if (notification.type == NotificationType.workout) {
                          return WorkoutNotificationCard(
                            title: notification.title,
                            description: notification.message,
                            time: _formatTime(notification.time),
                            workoutType: notification.workoutImage ?? 'default',
                            onTap: () => _markAsRead(notification.id),
                          );
                        } else {
                          return _buildPromotionCard(notification);
                        }
                      },
                    ),
          ),
        ],
      ),
    );
  }

  Widget _buildPromotionCard(NotificationItem notification) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 1),
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(color: Color(0xFFF1F7FD)),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: notification.color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(notification.icon, color: notification.color, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  notification.title,
                  style: const TextStyle(
                    fontFamily: 'Nunito',
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                    color: Color(0xFF003C5E),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  notification.message,
                  style: const TextStyle(
                    fontFamily: 'Nunito',
                    fontWeight: FontWeight.w400,
                    fontSize: 12,
                    color: Color(0xFF003C5E),
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  _formatTime(notification.time),
                  style: const TextStyle(
                    fontFamily: 'Nunito',
                    fontWeight: FontWeight.w400,
                    fontSize: 10,
                    color: Color(0xFF9EABBC),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatTime(DateTime time) {
    // Format to match Figma design: "12:53 - 30/10/2019"
    String hour = time.hour.toString().padLeft(2, '0');
    String minute = time.minute.toString().padLeft(2, '0');
    String day = time.day.toString();
    String month = time.month.toString();
    String year = time.year.toString();

    return '$hour:$minute - $day/$month/$year';
  }

  void _markAsRead(String id) {
    setState(() {
      // Find in workout notifications
      final workoutIndex = workoutNotifications.indexWhere((n) => n.id == id);
      if (workoutIndex != -1) {
        workoutNotifications[workoutIndex] = workoutNotifications[workoutIndex]
            .copyWith(isRead: true);
      }

      // Find in promotion notifications
      final promotionIndex = promotionNotifications.indexWhere(
        (n) => n.id == id,
      );
      if (promotionIndex != -1) {
        promotionNotifications[promotionIndex] =
            promotionNotifications[promotionIndex].copyWith(isRead: true);
      }
    });
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: TColors.primary.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Iconsax.notification,
              size: 50,
              color: TColors.primary,
            ),
          ),
          const SizedBox(height: TSizes.lg),
          Text(
            selectedTabIndex == 0
                ? 'No Workout Notifications'
                : 'No Promotions',
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF003C5E),
            ),
          ),
          const SizedBox(height: TSizes.sm),
          const Text(
            'You\'re all caught up!\nWe\'ll notify you when something new comes up.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14, color: Color(0xFF9EABBC)),
          ),
        ],
      ),
    );
  }

  // ignore: unused_element
  void _showFilterOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder:
          (context) => Container(
            padding: const EdgeInsets.all(TSizes.lg),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: TColors.borderPrimary,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: TSizes.lg),
                const Text(
                  'Notification Settings',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF003C5E),
                  ),
                ),
                const SizedBox(height: TSizes.lg),
                _buildSettingOption('Push Notifications', true),
                _buildSettingOption('Email Notifications', false),
                _buildSettingOption('Achievement Alerts', true),
                _buildSettingOption('Workout Reminders', true),
                _buildSettingOption('Social Updates', false),
                const SizedBox(height: TSizes.lg),
              ],
            ),
          ),
    );
  }

  Widget _buildSettingOption(String title, bool value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: TSizes.xs),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 16, color: Color(0xFF003C5E)),
          ),
          Switch(
            value: value,
            onChanged: (newValue) {
              // Implement setting change logic
            },
            activeColor: TColors.primary,
          ),
        ],
      ),
    );
  }
}

// Models
enum NotificationType {
  achievement,
  reminder,
  social,
  health,
  update,
  workout,
  promotion,
}

class NotificationItem {
  final String id;
  final NotificationType type;
  final String title;
  final String message;
  final DateTime time;
  final bool isRead;
  final IconData icon;
  final Color color;
  final String? workoutImage;

  NotificationItem({
    required this.id,
    required this.type,
    required this.title,
    required this.message,
    required this.time,
    required this.isRead,
    required this.icon,
    required this.color,
    this.workoutImage,
  });

  NotificationItem copyWith({
    String? id,
    NotificationType? type,
    String? title,
    String? message,
    DateTime? time,
    bool? isRead,
    IconData? icon,
    Color? color,
    String? workoutImage,
  }) {
    return NotificationItem(
      id: id ?? this.id,
      type: type ?? this.type,
      title: title ?? this.title,
      message: message ?? this.message,
      time: time ?? this.time,
      isRead: isRead ?? this.isRead,
      icon: icon ?? this.icon,
      color: color ?? this.color,
      workoutImage: workoutImage ?? this.workoutImage,
    );
  }
}
