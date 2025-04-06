import 'package:flutter/material.dart';
import '../../../userProfile/profile_data.dart';
import 'getTodayActivity.dart';
import 'prefer_target.dart';

/// Widget hiển thị tổng quan hoạt động của ngày hôm nay
class ActivitySummaryWidget extends StatefulWidget {
  final ProfileData profileData;

  const ActivitySummaryWidget({Key? key, required this.profileData})
    : super(key: key);

  @override
  State<ActivitySummaryWidget> createState() => _ActivitySummaryWidgetState();
}

class _ActivitySummaryWidgetState extends State<ActivitySummaryWidget> {
  late Future<TodayActivityData> _activityDataFuture;
  late Future<ActivityTarget> _targetDataFuture;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() {
    setState(() {
      _isLoading = true;
    });

    _activityDataFuture = GetTodayActivityService.getTodayActivity();
    _targetDataFuture = Future.value(
      ActivityTarget.getRecommendedTarget(widget.profileData),
    );

    Future.wait([_activityDataFuture, _targetDataFuture]).then((_) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            const SizedBox(height: 16),
            _buildActivitySummary(),
            const SizedBox(height: 24),
            _buildProgressSection(),
            const SizedBox(height: 24),
            _buildActivityList(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Today',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        IconButton(
          icon: const Icon(Icons.refresh),
          onPressed: _loadData,
          tooltip: 'Refresh data',
        ),
      ],
    );
  }

  Widget _buildActivitySummary() {
    return FutureBuilder<TodayActivityData>(
      future: _activityDataFuture,
      builder: (context, activitySnapshot) {
        return FutureBuilder<ActivityTarget>(
          future: _targetDataFuture,
          builder: (context, targetSnapshot) {
            if (activitySnapshot.connectionState == ConnectionState.waiting ||
                targetSnapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (activitySnapshot.hasError || targetSnapshot.hasError) {
              return Center(
                child: Column(
                  children: [
                    const Icon(
                      Icons.error_outline,
                      color: Colors.red,
                      size: 48,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Cannot load data: ${activitySnapshot.error ?? targetSnapshot.error}',
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.red),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _loadData,
                      child: const Text('Try again'),
                    ),
                  ],
                ),
              );
            }

            final activityData = activitySnapshot.data!;
            final targetData = targetSnapshot.data!;

            // Tính điểm dựa trên hoạt động thực tế
            final points =
                (activityData.distanceInKm * 10) +
                (activityData.steps / 100) +
                (activityData.calories / 10);

            return Column(
              children: [
                _buildSummaryCard(
                  title: 'Summary',
                  children: [
                    _buildSummaryItem(
                      icon: Icons.directions_run,
                      label: 'Distance',
                      value:
                          '${activityData.distanceInKm.toStringAsFixed(1)} km',
                      target:
                          '${targetData.targetDistance.toStringAsFixed(1)} km',
                      progress:
                          activityData.distanceInKm / targetData.targetDistance,
                    ),
                    _buildSummaryItem(
                      icon: Icons.directions_walk,
                      label: 'Số bước',
                      value: '${activityData.steps}',
                      target: '${targetData.targetSteps}',
                      progress: activityData.steps / targetData.targetSteps,
                    ),
                    _buildSummaryItem(
                      icon: Icons.local_fire_department,
                      label: 'Calories',
                      value: '${activityData.calories}',
                      target: '${targetData.targetCalories}',
                      progress:
                          activityData.calories / targetData.targetCalories,
                    ),
                    _buildSummaryItem(
                      icon: Icons.star,
                      label: 'Điểm',
                      value: '${points.round()}',
                      target: '${targetData.bonusPoints}',
                      progress: points / targetData.bonusPoints,
                    ),
                  ],
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildSummaryCard({
    required String title,
    required List<Widget> children,
  }) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryItem({
    required IconData icon,
    required String label,
    required String value,
    required String target,
    required double progress,
  }) {
    final isComplete = progress >= 1.0;
    final color = isComplete ? Colors.green : Colors.blue;

    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color),
              const SizedBox(width: 8),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const Spacer(),
              Text(
                '$value / $target',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          LinearProgressIndicator(
            value: progress.clamp(0.0, 1.0),
            backgroundColor: Colors.grey[300],
            valueColor: AlwaysStoppedAnimation<Color>(color),
            minHeight: 8,
            borderRadius: BorderRadius.circular(4),
          ),
          const SizedBox(height: 4),
          Text(
            '${(progress * 100).round()}% hoàn thành',
            style: TextStyle(fontSize: 12, color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressSection() {
    return FutureBuilder<TodayActivityData>(
      future: _activityDataFuture,
      builder: (context, activitySnapshot) {
        return FutureBuilder<ActivityTarget>(
          future: _targetDataFuture,
          builder: (context, targetSnapshot) {
            if (activitySnapshot.connectionState == ConnectionState.waiting ||
                targetSnapshot.connectionState == ConnectionState.waiting) {
              return const SizedBox.shrink();
            }

            if (activitySnapshot.hasError || targetSnapshot.hasError) {
              return const SizedBox.shrink();
            }

            final activityData = activitySnapshot.data!;
            final targetData = targetSnapshot.data!;

            // Tính tỷ lệ hoàn thành tổng thể
            final distanceProgress =
                activityData.distanceInKm / targetData.targetDistance;
            final stepsProgress = activityData.steps / targetData.targetSteps;
            final caloriesProgress =
                activityData.calories / targetData.targetCalories;

            final overallProgress =
                (distanceProgress + stepsProgress + caloriesProgress) / 3;

            return Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Tiến độ tổng thể',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        SizedBox(
                          height: 150,
                          width: 150,
                          child: CircularProgressIndicator(
                            value: overallProgress.clamp(0.0, 1.0),
                            backgroundColor: Colors.grey[300],
                            valueColor: AlwaysStoppedAnimation<Color>(
                              overallProgress >= 1.0
                                  ? Colors.green
                                  : Colors.blue,
                            ),
                            strokeWidth: 12,
                          ),
                        ),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              '${(overallProgress * 100).round()}%',
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const Text(
                              'Hoàn thành',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    _buildProgressIndicator(
                      label: 'Khoảng cách',
                      value: activityData.distanceInKm,
                      target: targetData.targetDistance,
                      icon: Icons.directions_run,
                    ),
                    const SizedBox(height: 8),
                    _buildProgressIndicator(
                      label: 'Số bước',
                      value: activityData.steps.toDouble(),
                      target: targetData.targetSteps.toDouble(),
                      icon: Icons.directions_walk,
                    ),
                    const SizedBox(height: 8),
                    _buildProgressIndicator(
                      label: 'Calories',
                      value: activityData.calories.toDouble(),
                      target: targetData.targetCalories.toDouble(),
                      icon: Icons.local_fire_department,
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildProgressIndicator({
    required String label,
    required double value,
    required double target,
    required IconData icon,
  }) {
    final progress = value / target;
    final isComplete = progress >= 1.0;
    final color = isComplete ? Colors.green : Colors.blue;

    return Row(
      children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: const TextStyle(fontSize: 14)),
              const SizedBox(height: 4),
              LinearProgressIndicator(
                value: progress.clamp(0.0, 1.0),
                backgroundColor: Colors.grey[300],
                valueColor: AlwaysStoppedAnimation<Color>(color),
                minHeight: 6,
                borderRadius: BorderRadius.circular(3),
              ),
            ],
          ),
        ),
        const SizedBox(width: 8),
        Text(
          '${value.toStringAsFixed(1)} / ${target.toStringAsFixed(1)}',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }

  Widget _buildActivityList() {
    return FutureBuilder<TodayActivityData>(
      future: _activityDataFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Lỗi: ${snapshot.error}'));
        }

        final activityData = snapshot.data!;
        final activities = activityData.activities;

        if (activities.isEmpty) {
          return Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Padding(
              padding: EdgeInsets.all(16.0),
              child: Center(
                child: Text(
                  'Chưa có hoạt động nào hôm nay',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              ),
            ),
          );
        }

        return Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Chi tiết hoạt động',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: activities.length,
                  itemBuilder: (context, index) {
                    final activity = activities[index];
                    return _buildActivityItem(activity);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildActivityItem(ActivityItem activity) {
    final hours = activity.timeInSeconds ~/ 3600;
    final minutes = (activity.timeInSeconds % 3600) ~/ 60;
    final seconds = activity.timeInSeconds % 60;
    final timeString =
        '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.access_time, size: 16),
                const SizedBox(width: 4),
                Text(
                  'Thời gian: $timeString',
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
                const Spacer(),
                Text(
                  '${activity.date.hour.toString().padLeft(2, '0')}:${activity.date.minute.toString().padLeft(2, '0')}',
                  style: const TextStyle(color: Colors.grey),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                _buildActivityMetric(
                  icon: Icons.directions_run,
                  label: 'Khoảng cách',
                  value: '${activity.distanceInKm.toStringAsFixed(1)} km',
                ),
                const SizedBox(width: 16),
                _buildActivityMetric(
                  icon: Icons.directions_walk,
                  label: 'Số bước',
                  value: '${activity.steps}',
                ),
                const SizedBox(width: 16),
                _buildActivityMetric(
                  icon: Icons.local_fire_department,
                  label: 'Calories',
                  value: '${activity.calories}',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActivityMetric({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 16, color: Colors.blue),
              const SizedBox(width: 4),
              Text(
                label,
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
