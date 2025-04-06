import 'package:fitness_tracker/screens/home/widgets/stats_item.dart';
import 'package:fitness_tracker/utils/constants/image_strings.dart';
import 'package:fitness_tracker/utils/helpers/helpers_function.dart';
import 'package:flutter/material.dart';
import 'package:fitness_tracker/utils/constants/colors.dart';
import 'package:fitness_tracker/utils/constants/sizes.dart';
import 'package:fitness_tracker/features/services/home_service/getTodayActivity.dart';
import 'package:fitness_tracker/features/services/home_service/prefer_target.dart';
import 'package:fitness_tracker/userProfile/profile_data.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class CustomPopupShape extends ShapeBorder {
  final double arrowWidth = 20.0;
  final double arrowHeight = 10.0;
  final double borderRadius = 12.0;
  final Offset targetCenter;
  final bool isArrowLeft;

  const CustomPopupShape({
    required this.targetCenter,
    required this.isArrowLeft,
  });

  @override
  EdgeInsetsGeometry get dimensions => EdgeInsets.zero;

  @override
  Path getInnerPath(Rect rect, {TextDirection? textDirection}) {
    return getOuterPath(rect, textDirection: textDirection);
  }

  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) {
    final path = Path();

    // Tính toán vị trí mũi tên dựa trên targetCenter
    final double arrowX = rect.left + targetCenter.dx;

    // Vẽ mũi tên
    path.moveTo(arrowX - arrowWidth / 2, rect.bottom);
    path.lineTo(arrowX, rect.bottom + arrowHeight);
    path.lineTo(arrowX + arrowWidth / 2, rect.bottom);

    // Vẽ hình chữ nhật bo góc
    path.addRRect(RRect.fromRectAndRadius(rect, Radius.circular(borderRadius)));

    return path;
  }

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection? textDirection}) {}

  @override
  ShapeBorder scale(double t) => this;
}

class WorkoutStats extends StatefulWidget {
  final ProfileData? profileData;

  const WorkoutStats({super.key, this.profileData});

  @override
  State<WorkoutStats> createState() => _WorkoutStatsState();
}

class _WorkoutStatsState extends State<WorkoutStats> {
  int _activeTabIndex = 0;
  final List<String> _weekDays = [
    'MON',
    'TUE',
    'WED',
    'THU',
    'FRI',
    'SAT',
    'SUN',
  ];

  // Dữ liệu cho từng loại bài tập
  final List<Map<String, dynamic>> _exerciseData = [
    {
      'name': 'Dumbbell',
      'icon': Image.asset(Images.dumbbell),
      'calories': '628',
      'chartData': [
        {'grey': 0.7, 'color': 0.5, 'value': '320'},
        {'grey': 0.9, 'color': 0.7, 'value': '400'},
        {'grey': 1.0, 'color': 0.8, 'value': '628'},
        {'grey': 0.8, 'color': 0.6, 'value': '380'},
        {'grey': 0.6, 'color': 0.4, 'value': '250'},
        {'grey': 0.7, 'color': 0.5, 'value': '300'},
        {'grey': 0.5, 'color': 0.3, 'value': '200'},
      ],
    },
    {
      'name': 'Treadmill',
      'icon': Image.asset(Images.treadmill),
      'calories': '235',
      'chartData': [
        {'grey': 0.5, 'color': 0.3},
        {'grey': 0.8, 'color': 0.6},
        {'grey': 0.6, 'color': 0.4},
        {'grey': 1.0, 'color': 0.8},
        {'grey': 0.7, 'color': 0.5},
        {'grey': 0.9, 'color': 0.7},
        {'grey': 0.8, 'color': 0.6},
      ],
    },
    {
      'name': 'Rope',
      'icon': Image.asset(Images.rope),
      'calories': '432',
      'chartData': [
        {'grey': 0.8, 'color': 0.6},
        {'grey': 0.7, 'color': 0.5},
        {'grey': 0.9, 'color': 0.7},
        {'grey': 0.6, 'color': 0.4},
        {'grey': 1.0, 'color': 0.8},
        {'grey': 0.8, 'color': 0.6},
        {'grey': 0.7, 'color': 0.5},
      ],
    },
  ];

  // Dữ liệu thống kê sẽ được cập nhật từ API
  List<Map<String, dynamic>> _statsData = [];

  // Biến để lưu trữ dữ liệu hoạt động
  TodayActivityData? _todayActivityData;
  ActivityTarget? _activityTarget;
  bool _isLoading = true;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _loadActivityData();
  }

  Future<void> _loadActivityData() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      // Lấy dữ liệu hoạt động từ API
      final activityData = await GetTodayActivityService.getTodayActivity();

      // Lấy mục tiêu dựa trên profile
      ActivityTarget targetData;
      if (widget.profileData != null) {
        targetData = ActivityTarget.getRecommendedTarget(widget.profileData!);
      } else {
        // Nếu không có profile, tạo một profile mặc định
        final defaultProfile = ProfileData(
          weight: 60.0,
          height: 170.0,
          age: 30,
          gender: 'male',
          activityLevel: 'moderate',
          goal: 'maintain',
        );
        targetData = ActivityTarget.getRecommendedTarget(defaultProfile);
      }

      // Tính điểm dựa trên hoạt động thực tế
      final points =
          (activityData.distanceInKm * 10) +
          (activityData.steps / 100) +
          (activityData.calories / 10);

      // Cập nhật dữ liệu thống kê
      _statsData = [
        {
          'value': activityData.distanceInKm.toStringAsFixed(1),
          'unit': 'km',
          'label': 'Distance',
          'icon': Icons.directions_run,
          'target': targetData.targetDistance,
          'current': activityData.distanceInKm,
        },
        {
          'value': activityData.steps.toString(),
          'unit': '',
          'label': 'Steps',
          'icon': Icons.directions_walk,
          'target': targetData.targetSteps.toDouble(),
          'current': activityData.steps.toDouble(),
        },
        {
          'value': activityData.calories.toString(),
          'unit': '',
          'label': 'Calories',
          'icon': Icons.local_fire_department,
          'target': targetData.targetCalories.toDouble(),
          'current': activityData.calories.toDouble(),
        },
        {
          'value': points.round().toString(),
          'unit': '',
          'label': 'Points',
          'icon': Icons.star,
          'target': targetData.bonusPoints.toDouble(),
          'current': points,
        },
      ];

      setState(() {
        _todayActivityData = activityData;
        _activityTarget = targetData;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Unable to load data: $e';
        _isLoading = false;
      });

      // Sử dụng dữ liệu mặc định nếu có lỗi
      _statsData = [
        {
          'value': '0.0',
          'unit': 'km',
          'label': 'Distance',
          'icon': Icons.directions_run,
          'target': 5.0,
          'current': 0.0,
        },
        {
          'value': '0',
          'unit': '',
          'label': 'Steps',
          'icon': Icons.directions_walk,
          'target': 10000.0,
          'current': 0.0,
        },

        {
          'value': '0',
          'unit': '',
          'label': 'Calories',
          'icon': Icons.local_fire_department,
          'target': 800.0,
          'current': 0.0,
        },
        {
          'value': '0',
          'unit': '',
          'label': 'Points',
          'icon': Icons.star,
          'target': 2000.0,
          'current': 0.0,
        },
      ];
    }
  }

  void _toggleTab(int index) {
    setState(() {
      _activeTabIndex = index;
    });
  }

  void _showPopupMenu(
    BuildContext context,
    int index,
    Offset position,
    double value,
    BuildContext columnContext,
  ) {
    final RenderBox overlay =
        Overlay.of(context).context.findRenderObject() as RenderBox;
    final RenderBox columnBox = columnContext.findRenderObject() as RenderBox;
    final Size screenSize = overlay.size;
    const double popupWidth = 100.0;

    // Lấy vị trí chính xác của cột
    final Offset columnPosition = columnBox.localToGlobal(Offset.zero);
    final double columnCenterX = columnPosition.dx + columnBox.size.width / 2;

    bool isArrowLeft;
    double left;
    double right;
    double arrowPosition;

    if (columnCenterX + popupWidth / 2 > screenSize.width - 20) {
      // Nếu popup vượt quá bên phải màn hình
      isArrowLeft = false;
      left = screenSize.width - popupWidth - 20;
      right = 20;
      arrowPosition = columnCenterX - left;
    } else if (columnCenterX - popupWidth / 2 < 20) {
      // Nếu popup vượt quá bên trái màn hình
      isArrowLeft = true;
      left = 20;
      right = screenSize.width - popupWidth - 20;
      arrowPosition = columnCenterX - left;
    } else {
      // Trường hợp bình thường, căn giữa popup với cột
      isArrowLeft = true;
      left = columnCenterX - popupWidth / 2;
      right = screenSize.width - (columnCenterX + popupWidth / 2);
      arrowPosition = popupWidth / 2;
    }

    showMenu(
      context: context,
      position: RelativeRect.fromLTRB(
        left,
        columnPosition.dy - 80,
        right,
        columnPosition.dy,
      ),
      shape: CustomPopupShape(
        targetCenter: Offset(arrowPosition, 0),
        isArrowLeft: isArrowLeft,
      ),
      color: Colors.white,
      elevation: 8,
      items: [
        PopupMenuItem(
          enabled: false,
          padding: EdgeInsets.zero,
          child: Container(
            width: popupWidth,
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '${value.toStringAsFixed(1)}km',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                Text(
                  _weekDays[index],
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall?.copyWith(color: Colors.grey),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final activeExercise = _exerciseData[_activeTabIndex];
    final dark = HelpersFunction.isDarkMode(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: TSizes.defaultSpace),
      width: MediaQuery.of(context).size.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Stats Row
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child:
                  _isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : _errorMessage.isNotEmpty
                      ? Column(
                        children: [
                          const Icon(
                            Icons.error_outline,
                            color: Colors.red,
                            size: 48,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            _errorMessage,
                            textAlign: TextAlign.center,
                            style: const TextStyle(color: Colors.red),
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: _loadActivityData,
                            child: const Text('Try again'),
                          ),
                        ],
                      )
                      : Row(
                        children: [
                          const SizedBox(width: 16),
                          ..._statsData.map(
                            (stat) => Stat_Item(
                              context: context,
                              value: stat['value'] + (stat['unit'] ?? ''),
                              label: stat['label'],
                              icon: stat['icon'],
                              current: stat['current'].toDouble(),
                              target: stat['target'].toDouble(),
                            ),
                          ),
                        ],
                      ),
            ),
          ),
          const SizedBox(height: TSizes.spaceBtwSections),

          // Total Kilocalories
          Center(
            child: Column(
              children: [
                Text(
                  '${_todayActivityData?.calories ?? 0} Kcal',
                  style: Theme.of(context).textTheme.displaySmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: dark ? TColors.white : const Color(0xFF1D1517),
                  ),
                ),
                Text(
                  'Today',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: const Color(0xFF7B6F72),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: TSizes.spaceBtwSections),

          // Activity Chart
          SizedBox(
            height: 240, // Tăng chiều cao để chứa cả ngày
            child: Column(
              children: [
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: List.generate(
                      activeExercise['chartData'].length,
                      (index) => Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          GestureDetector(
                            onTapDown: (TapDownDetails details) {
                              final RenderBox box =
                                  context.findRenderObject() as RenderBox;
                              final Offset localPosition = box.localToGlobal(
                                Offset.zero,
                              );
                              final double columnCenterX =
                                  localPosition.dx + 14 / 2;

                              _showPopupMenu(
                                context,
                                index,
                                Offset(columnCenterX, localPosition.dy),
                                activeExercise['chartData'][index]['grey']
                                    .toDouble(),
                                context,
                              );
                            },
                            child: _buildChartBar(
                              context,
                              index,
                              activeExercise['chartData'][index]['grey']
                                  .toDouble(),
                              activeExercise['chartData'][index]['color']
                                  .toDouble(),
                              index % 2 == 0,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            _weekDays[index],
                            style: Theme.of(
                              context,
                            ).textTheme.bodySmall?.copyWith(
                              color: const Color(0xFF7B6F72),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: TSizes.spaceBtwSections),

          // Exercise Types
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Padding(
              padding: const EdgeInsets.only(bottom: TSizes.spaceBtwSections),
              child: Row(
                children: List.generate(
                  _exerciseData.length,
                  (index) => Padding(
                    padding: EdgeInsets.only(
                      right:
                          index != _exerciseData.length - 1
                              ? TSizes.spaceBtwItems
                              : 0,
                    ),
                    child: GestureDetector(
                      onTap: () => _toggleTab(index),
                      child: _buildExerciseType(
                        context,
                        _exerciseData[index]['icon'],
                        _exerciseData[index]['name'],
                        _exerciseData[index]['calories'],
                        _activeTabIndex == index,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChartBar(
    BuildContext context,
    int index,
    double heightGrey,
    double heightColor,
    bool isActive,
  ) {
    const double totalHeight = 180;
    const double barWidth = 14;
    final Color fillColor = isActive ? Colors.black : TColors.primary;

    return Builder(
      builder:
          (columnContext) => GestureDetector(
            onTapDown: (TapDownDetails details) {
              _showPopupMenu(
                context,
                index,
                details.globalPosition,
                heightGrey * 5,
                columnContext,
              );
            },
            child: Container(
              width: barWidth,
              height: totalHeight,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(7),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    width: barWidth,
                    height: totalHeight * heightColor,
                    decoration: BoxDecoration(
                      color: fillColor,
                      borderRadius: BorderRadius.circular(7),
                    ),
                  ),
                ],
              ),
            ),
          ),
    );
  }

  Widget _buildExerciseType(
    BuildContext context,
    dynamic icon,
    String name,
    String calories,
    bool isActive,
  ) {
    final textColor = isActive ? Colors.white : TColors.black;
    final backgroundColor = isActive ? TColors.primary : Colors.white;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: TSizes.xl,
        vertical: TSizes.lg,
      ),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: TColors.primary.withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, 4),
            spreadRadius: 0,
          ),
        ],
        border:
            !isActive
                ? Border(
                  top: BorderSide(
                    color: TColors.primary.withOpacity(0.6),
                    width: 3,
                  ),
                )
                : null,
      ),
      child: Column(
        children: [
          if (icon is Image)
            SizedBox(
              width: 32,
              height: 32,
              child: ColorFiltered(
                colorFilter: ColorFilter.mode(textColor, BlendMode.srcIn),
                child: icon,
              ),
            )
          else if (icon is IconData)
            Icon(icon, color: textColor, size: 40),
          const SizedBox(height: TSizes.sm),
          Text(
            '$calories Kcal',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
              color: textColor,
            ),
          ),
          Text(
            name,
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(color: textColor),
          ),
        ],
      ),
    );
  }
}
