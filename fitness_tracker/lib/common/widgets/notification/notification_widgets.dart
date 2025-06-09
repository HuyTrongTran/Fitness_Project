import 'package:fitness_tracker/utils/constants/image_strings.dart';
import 'package:flutter/material.dart';

/// Tab Switcher Widget matching Figma design
class NotificationTabSwitcher extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onTabChanged;
  final List<String> tabs;

  const NotificationTabSwitcher({
    super.key,
    required this.selectedIndex,
    required this.onTabChanged,
    required this.tabs,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 16),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: const Color(0xFFF7F8F8),
        borderRadius: BorderRadius.circular(99),
      ),
      child: Row(
        children:
            tabs.asMap().entries.map((entry) {
              int index = entry.key;
              String tab = entry.value;
              bool isSelected = index == selectedIndex;

              return Expanded(
                child: GestureDetector(
                  onTap: () => onTabChanged(index),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 8,
                      horizontal: 31,
                    ),
                    decoration: BoxDecoration(
                      gradient:
                          isSelected
                              ? const LinearGradient(
                                colors: [Color(0xFF92A3FD), Color(0xFF9DCEFF)],
                                begin: Alignment.topRight,
                                end: Alignment.bottomLeft,
                              )
                              : null,
                      borderRadius: BorderRadius.circular(99),
                    ),
                    child: Text(
                      tab,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color:
                            isSelected ? Colors.white : const Color(0xFF72777A),
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        fontFamily: 'Poppins',
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
      ),
    );
  }
}

/// Workout Notification Card matching Figma design
class WorkoutNotificationCard extends StatelessWidget {
  final String title;
  final String description;
  final String time;
  final String workoutType;
  final VoidCallback? onTap;

  const WorkoutNotificationCard({
    super.key,
    required this.title,
    required this.description,
    required this.time,
    required this.workoutType,
    this.onTap,
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 1),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(8),
          child: Container(
            width: 375,
            constraints: const BoxConstraints(
              minHeight: 70, // Minimum height to prevent too small cards
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: const BoxDecoration(
              color: Color(0xFFF1F7FD),
              borderRadius: BorderRadius.all(Radius.circular(8)),
            ),
            child: IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Workout icon with gradient background
                  Container(
                    width: 56,
                    height: 56,
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(28),
                      gradient: const LinearGradient(
                        colors: [Color(0xFF9AC1FF), Color(0xFF93A7FD)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: _buildWorkoutIcon(),
                  ),
                  const SizedBox(width: 12),
                  // Text content
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          title,
                          style: const TextStyle(
                            fontFamily: 'Nunito',
                            fontWeight: FontWeight.w700,
                            fontSize: 14,
                            height: 1.3,
                            color: Color(0xFF003C5E),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          description,
                          style: const TextStyle(
                            fontFamily: 'Nunito',
                            fontWeight: FontWeight.w400,
                            fontSize: 12,
                            height: 1.3,
                            color: Color(0xFF003C5E),
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          time,
                          style: const TextStyle(
                            fontFamily: 'Nunito',
                            fontWeight: FontWeight.w400,
                            fontSize: 10,
                            height: 1.3,
                            color: Color(0xFF9EABBC),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildWorkoutIcon() {
    String imagePath;

    // Since workoutType now contains the full image path, we can use it directly
    // or map it properly based on the actual path values
    switch (workoutType) {
      case 'assets/icons/app_icons/activity_icons/body_back.png':
        imagePath = Images.body_back;
        break;
      case 'assets/icons/app_icons/activity_icons/bicep.png':
        imagePath = Images.bicep;
        break;
      case 'assets/icons/app_icons/activity_icons/body_butt.png':
        imagePath = Images.body_butt;
        break;
      default:
        // If workoutType is already a valid path, use it directly
        if (workoutType.isNotEmpty && workoutType != 'default') {
          imagePath = workoutType;
        } else {
          imagePath = Images.dumbbell;
        }
    }

    return ClipOval(
      child: Container(
        width: 32,
        height: 32,
        child: Image.asset(
          imagePath,
          width: 29,
          height: 29,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return Container(
              width: 29,
              height: 29,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.fitness_center,
                color: Colors.grey,
                size: 16,
              ),
            );
          },
        ),
      ),
    );
  }
}

/// Settings Menu Icon matching Figma design
class NotificationSettingsIcon extends StatelessWidget {
  final VoidCallback? onTap;

  const NotificationSettingsIcon({super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 24,
        height: 24,
        padding: const EdgeInsets.all(2),
        child: CustomPaint(painter: SettingsIconPainter()),
      ),
    );
  }
}

class SettingsIconPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = const Color(0xFF040415)
          ..strokeWidth = 2
          ..style = PaintingStyle.stroke;

    // Draw the four dots as in the Figma design
    final dotSize = 2.0;
    final spacing = 5.0;

    // Top-left dot
    canvas.drawRect(Rect.fromLTWH(2, 2, dotSize * 5, dotSize * 5), paint);

    // Top-right dot
    canvas.drawRect(
      Rect.fromLTWH(2 + spacing + dotSize * 5, 2, dotSize * 5, dotSize * 5),
      paint,
    );

    // Bottom-left dot
    canvas.drawRect(
      Rect.fromLTWH(2, 2 + spacing + dotSize * 5, dotSize * 5, dotSize * 5),
      paint,
    );

    // Bottom-right dot
    canvas.drawRect(
      Rect.fromLTWH(
        2 + spacing + dotSize * 5,
        2 + spacing + dotSize * 5,
        dotSize * 5,
        dotSize * 5,
      ),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// iPhone Status Bar Widget
class IPhoneStatusBar extends StatelessWidget {
  const IPhoneStatusBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 375,
      height: 44,
      color: const Color(0xFFF9F9F9).withOpacity(0.94),
      child: Stack(
        children: [
          // Time
          const Positioned(
            left: 20,
            top: 13,
            child: Text(
              '9:41',
              style: TextStyle(
                fontFamily: 'SF Pro Text',
                fontWeight: FontWeight.w600,
                fontSize: 15,
                letterSpacing: -0.165,
                color: Color(0xFF222222),
              ),
            ),
          ),

          // Status indicators (right side)
          Positioned(
            right: 20,
            top: 15,
            child: Row(
              children: [
                // Signal strength
                _buildSignalStrength(),
                const SizedBox(width: 5),

                // WiFi
                _buildWiFiIcon(),
                const SizedBox(width: 5),

                // Battery
                _buildBatteryIcon(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSignalStrength() {
    return SizedBox(
      width: 17,
      height: 11,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(width: 3, height: 4, color: Colors.black),
          Container(width: 3, height: 6, color: Colors.black),
          Container(width: 3, height: 8, color: Colors.black),
          Container(width: 3, height: 11, color: Colors.black),
        ],
      ),
    );
  }

  Widget _buildWiFiIcon() {
    return const Icon(Icons.wifi, size: 15, color: Colors.black);
  }

  Widget _buildBatteryIcon() {
    return Container(
      width: 24,
      height: 11,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black.withOpacity(0.36), width: 1),
        borderRadius: BorderRadius.circular(2),
      ),
      child: Stack(
        children: [
          // Battery fill
          Positioned(
            left: 2,
            top: 2,
            child: Container(
              width: 18,
              height: 7,
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(1),
              ),
            ),
          ),

          // Battery tip
          Positioned(
            right: -1,
            top: 4,
            child: Container(
              width: 1.5,
              height: 4,
              color: Colors.black.withOpacity(0.36),
            ),
          ),
        ],
      ),
    );
  }
}
