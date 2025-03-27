import 'package:fitness_tracker/screens/runSessionFeature/runSession.dart';
import 'package:fitness_tracker/screens/runSessionFeature/runTrackingScreen.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';

class RunResultPage extends StatefulWidget {
  const RunResultPage({super.key});

  @override
  _RunResultPageState createState() => _RunResultPageState();
}

class _RunResultPageState extends State<RunResultPage> {
  DateTime _selectedDate = DateTime.now();
  List<DateTime> _weekDates = [];
  RunSession? _selectedSession;
  bool _hasSessionData = false;

  @override
  void initState() {
    super.initState();
    _generateWeekDates();
    _updateSelectedSession();
  }

  // Tạo danh sách 7 ngày (hôm nay ± 3 ngày)
  void _generateWeekDates() {
    DateTime now = DateTime.now();
    _weekDates = List.generate(7, (index) {
      return now.subtract(Duration(days: 3 - index));
    });
  }

  // Cập nhật phiên chạy được chọn dựa trên ngày
  void _updateSelectedSession() {
    setState(() {
      try {
        _selectedSession = RunSessionManager.runSessions.lastWhere(
          (session) =>
              session.date.day == _selectedDate.day &&
              session.date.month == _selectedDate.month &&
              session.date.year == _selectedDate.year,
        );
        _hasSessionData = true;
      } catch (e) {
        _selectedSession = RunSession(
          date: _selectedDate,
          elapsedTimeInSeconds: 0,
          distanceInKm: 0.0,
          routePoints: [],
          steps: 0,
          calories: 0.0,
        );
        _hasSessionData = false;
      }
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
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text("Your session"),
        actions: [
          IconButton(icon: const Icon(Icons.more_vert), onPressed: () {}),
        ],
      ),
      body: SingleChildScrollView(
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
                        setState(() {
                          _selectedDate = date;
                          _updateSelectedSession();
                        });
                      },
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 8),
                        padding: const EdgeInsets.symmetric(
                          vertical: 8,
                          horizontal: 16,
                        ),
                        decoration: BoxDecoration(
                          color: isSelected ? Colors.blue : Colors.grey[200],
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Center(
                          child: Text(
                            date.day == DateTime.now().day
                                ? "Today, ${DateFormat('d MMM').format(date)}"
                                : DateFormat('d').format(date),
                            style: Theme.of(
                              context,
                            ).textTheme.bodyLarge?.copyWith(
                              color: isSelected ? Colors.white : Colors.black,
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
                      style: TextStyle(color: Colors.grey, fontSize: 16),
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
                      Container(
                        width: 80,
                        height: 80,
                        child: GoogleMap(
                          initialCameraPosition: CameraPosition(
                            target:
                                _selectedSession!.routePoints.isNotEmpty
                                    ? _selectedSession!.routePoints.first
                                    : const LatLng(10.7769, 106.7009),
                            zoom: 14,
                          ),
                          polylines:
                              _selectedSession!.routePoints.isNotEmpty
                                  ? {
                                    Polyline(
                                      polylineId: const PolylineId('route'),
                                      points: _selectedSession!.routePoints,
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
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder:
                                        (context) => const RunTrackingPage(),
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
