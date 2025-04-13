import 'package:fitness_tracker/common/widgets/appbar/appbar.dart';
import 'package:fitness_tracker/screens/runSessionFeature/runResult/controllers/runViewMap.dart';
import 'package:fitness_tracker/screens/runSessionFeature/runSession.dart';
import 'package:fitness_tracker/utils/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:fitness_tracker/features/services/run_history_service.dart';

class RunResultPage extends StatefulWidget {
  final RunSession session;

  const RunResultPage({super.key, required this.session});

  @override
  _RunResultPageState createState() => _RunResultPageState();
}

class _RunResultPageState extends State<RunResultPage> {
  DateTime _selectedDate = DateTime.now();
  List<DateTime> _weekDates = [];
  RunSession? _selectedSession;
  bool _hasSessionData = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _generateWeekDates();
    _selectedSession = widget.session;
    _hasSessionData = true;
    _selectedDate = widget.session.date;
    _loadRunHistory();
  }

  Future<void> _loadRunHistory() async {
    setState(() => _isLoading = true);
    try {
      // Tính toán startDate và endDate dựa trên _weekDates
      final startDate = _weekDates.first;
      final endDate = _weekDates.last;

      // Gọi API để lấy lịch sử chạy
      final history = await RunHistoryService.getRunHistory(
        startDate: startDate,
        endDate: endDate,
      );

      // Cập nhật RunSessionManager với dữ liệu mới
      RunSessionManager.clearSessions();
      for (var session in history) {
        RunSessionManager.addSession(session);
      }

      // Thêm session hiện tại nếu chưa có trong lịch sử
      if (!history.any(
        (s) =>
            s.date.day == widget.session.date.day &&
            s.date.month == widget.session.date.month &&
            s.date.year == widget.session.date.year,
      )) {
        RunSessionManager.addSession(widget.session);
      }
    } catch (e) {
      print('Error loading run history: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _onDateSelected(DateTime date) async {
    setState(() {
      _selectedDate = date;
      try {
        _selectedSession = RunSessionManager.runSessions.lastWhere(
          (session) =>
              session.date.day == _selectedDate.day &&
              session.date.month == _selectedDate.month &&
              session.date.year == _selectedDate.year,
        );
        _hasSessionData = true;
      } catch (e) {
        _hasSessionData = false;
      }
    });
  }

  // Tạo danh sách 7 ngày (hôm nay ± 3 ngày)
  void _generateWeekDates() {
    DateTime now = DateTime.now();
    _weekDates = List.generate(7, (index) {
      return now.subtract(Duration(days: 3 - index));
    });
  }

  // Định dạng thời gian (HH:MM:SS hoặc MM:SS)
  String _formatTime(int seconds) {
    int hours = seconds ~/ 3600;
    int minutes = (seconds % 3600) ~/ 60;
    int secs = seconds % 60;
    return "${hours > 0 ? '${hours.toString().padLeft(2, '0')}:' : ''}${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const TAppBar(
        centerTitle: true,
        showBackButton: true,
        color: TColors.black,
        title: Text("Your session"),
      ),
      body:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Thanh chọn ngày
                      SizedBox(
                        height: 50,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: _weekDates.length,
                          itemBuilder: (context, index) {
                            DateTime date = _weekDates[index];
                            bool isSelected =
                                date.day == _selectedDate.day &&
                                date.month == _selectedDate.month &&
                                date.year == _selectedDate.year;
                            return GestureDetector(
                              onTap: () {
                                _onDateSelected(date);
                              },
                              child: Container(
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                ),
                                padding: const EdgeInsets.symmetric(
                                  vertical: 8,
                                  horizontal: 16,
                                ),
                                decoration: BoxDecoration(
                                  color:
                                      isSelected
                                          ? TColors.primary
                                          : Colors.grey[200],
                                  borderRadius: BorderRadius.circular(32),
                                ),
                                child: Center(
                                  child: Text(
                                    date.day == DateTime.now().day
                                        ? "Today, ${DateFormat('d MMM').format(date)}"
                                        : DateFormat('d').format(date),
                                    style: Theme.of(
                                      context,
                                    ).textTheme.bodyLarge?.copyWith(
                                      color:
                                          isSelected
                                              ? Colors.white
                                              : Colors.black,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Kiểm tra nếu không có dữ liệu phiên chạy
                      if (!_hasSessionData) ...[
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 10,
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                          child: const Center(
                            child: Text(
                              "No session data for this date",
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                      ] else ...[
                        // Bản đồ nhỏ và thời gian
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 10,
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              // Bản đồ nhỏ
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder:
                                          (context) => RunViewMapPage(
                                            session: _selectedSession!,
                                          ),
                                    ),
                                  );
                                },
                                child: Container(
                                  width: 80,
                                  height: 80,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                      color: Colors.grey[300]!,
                                    ),
                                  ),
                                  child: Stack(
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: GoogleMap(
                                          initialCameraPosition: CameraPosition(
                                            target:
                                                _selectedSession!
                                                        .routePoints
                                                        .isNotEmpty
                                                    ? _selectedSession!
                                                        .routePoints
                                                        .first
                                                    : const LatLng(
                                                      10.7769,
                                                      106.7009,
                                                    ),
                                            zoom: 14,
                                          ),
                                          polylines:
                                              _selectedSession!
                                                      .routePoints
                                                      .isNotEmpty
                                                  ? {
                                                    Polyline(
                                                      polylineId:
                                                          const PolylineId(
                                                            'route',
                                                          ),
                                                      points:
                                                          _selectedSession!
                                                              .routePoints
                                                              .map(
                                                                (
                                                                  point,
                                                                ) => LatLng(
                                                                  point
                                                                      .latitude,
                                                                  point
                                                                      .longitude,
                                                                ),
                                                              )
                                                              .toList(),
                                                      color: Colors.red,
                                                      width: 5,
                                                    ),
                                                  }
                                                  : {},
                                          liteModeEnabled: true,
                                          zoomControlsEnabled: false,
                                          zoomGesturesEnabled: false,
                                          scrollGesturesEnabled: false,
                                          rotateGesturesEnabled: false,
                                          tiltGesturesEnabled: false,
                                          onTap: null,
                                        ),
                                      ),
                                      Positioned.fill(
                                        child: Container(
                                          color: Colors.transparent,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(width: 16),
                              // Tổng thời gian và nút "View run map"
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      "Total time",
                                      style: TextStyle(
                                        color: Colors.grey,
                                        fontSize: 14,
                                      ),
                                    ),
                                    Text(
                                      _formatTime(
                                        _selectedSession!.elapsedTimeInSeconds,
                                      ),
                                      style: Theme.of(
                                        context,
                                      ).textTheme.bodyLarge?.copyWith(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    TextButton(
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder:
                                                (context) => RunViewMapPage(
                                                  session: _selectedSession!,
                                                ),
                                          ),
                                        );
                                      },
                                      child: const Text(
                                        "View run map",
                                        style: TextStyle(
                                          color: Colors.blue,
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                      const SizedBox(height: 16),
                      // Thông tin chi tiết
                      _buildInfoRow(
                        Icons.directions_run,
                        "Distance",
                        "${_selectedSession!.distanceInKm.toStringAsFixed(2)} km",
                      ),
                      const SizedBox(height: 16),
                      _buildInfoRow(
                        Icons.directions_walk,
                        "Step",
                        "${_selectedSession!.steps} steps",
                      ),
                      const SizedBox(height: 16),
                      _buildInfoRow(
                        Icons.local_fire_department,
                        "Calories",
                        "${_selectedSession!.calories.toStringAsFixed(0)} calo",
                      ),
                    ],
                  ),
                ),
              ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 10, spreadRadius: 2),
        ],
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.blue, size: 24),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              label,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Text(
            value,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
