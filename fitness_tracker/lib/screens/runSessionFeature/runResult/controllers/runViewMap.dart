import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:iconsax/iconsax.dart';
import 'package:fitness_tracker/utils/constants/colors.dart';
import 'package:fitness_tracker/screens/runSessionFeature/runSession.dart';

class RunViewMapPage extends StatefulWidget {
  final RunSession session;

  const RunViewMapPage({super.key, required this.session});

  @override
  _RunViewMapPageState createState() => _RunViewMapPageState();
}

class _RunViewMapPageState extends State<RunViewMapPage> {
  GoogleMapController? _mapController;
  bool _isExpanded = false;
  bool _is3DMode = false;
  double _currentZoom = 14.0;

  @override
  void initState() {
    super.initState();
    print(
      'Route Points received in RunViewMapPage: ${widget.session.routePoints.length} points',
    );
    print(
      'First point: ${widget.session.routePoints.isNotEmpty ? widget.session.routePoints.first : "No points"}',
    );
    print(
      'Last point: ${widget.session.routePoints.isNotEmpty ? widget.session.routePoints.last : "No points"}',
    );
  }

  String _formatTime(int seconds) {
    int hours = seconds ~/ 3600;
    int minutes = (seconds % 3600) ~/ 60;
    int secs = seconds % 60;
    return "${hours > 0 ? '${hours.toString().padLeft(2, '0')}:' : ''}${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}";
  }

  void _toggle3DMode() {
    setState(() {
      _is3DMode = !_is3DMode;
      _centerMapToRoute();
    });
  }

  void _centerMapToRoute() {
    if (_mapController == null || widget.session.routePoints.isEmpty) return;

    // Tính toán bounds để hiển thị toàn bộ quãng đường
    double minLat = widget.session.routePoints.first.latitude;
    double maxLat = widget.session.routePoints.first.latitude;
    double minLng = widget.session.routePoints.first.longitude;
    double maxLng = widget.session.routePoints.first.longitude;

    for (var point in widget.session.routePoints) {
      minLat = point.latitude < minLat ? point.latitude : minLat;
      maxLat = point.latitude > maxLat ? point.latitude : maxLat;
      minLng = point.longitude < minLng ? point.longitude : minLng;
      maxLng = point.longitude > maxLng ? point.longitude : maxLng;
    }

    _mapController?.animateCamera(
      CameraUpdate.newLatLngBounds(
        LatLngBounds(
          southwest: LatLng(minLat, minLng),
          northeast: LatLng(maxLat, maxLng),
        ),
        50, // padding
      ),
    );
  }

  void _zoomIn() {
    setState(() {
      _currentZoom = (_currentZoom + 1).clamp(1, 20);
      _mapController?.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: widget.session.routePoints.first,
            zoom: _currentZoom,
            tilt: _is3DMode ? 45 : 0,
          ),
        ),
      );
    });
  }

  void _zoomOut() {
    setState(() {
      _currentZoom = (_currentZoom - 1).clamp(1, 20);
      _mapController?.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: widget.session.routePoints.first,
            zoom: _currentZoom,
            tilt: _is3DMode ? 45 : 0,
          ),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    double navbarHeight = _isExpanded ? size.height * 0.5 : size.height * 0.15;
    double buttonsTop =
        _isExpanded ? (size.height * 0.5 - 220) : size.height * 0.4;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text("Route Details"),
      ),
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target:
                  widget.session.routePoints.isNotEmpty
                      ? widget.session.routePoints.first
                      : const LatLng(10.7769, 106.7009),
              zoom: _currentZoom,
              tilt: _is3DMode ? 45 : 0,
            ),
            onMapCreated: (GoogleMapController controller) {
              _mapController = controller;
              _centerMapToRoute();
            },
            polylines: {
              Polyline(
                polylineId: const PolylineId('route'),
                points: widget.session.routePoints,
                color: Colors.blue,
                width: 5,
              ),
            },
            markers: {
              if (widget.session.routePoints.isNotEmpty) ...[
                Marker(
                  markerId: const MarkerId('start'),
                  position: widget.session.routePoints.first,
                  icon: BitmapDescriptor.defaultMarkerWithHue(
                    BitmapDescriptor.hueGreen,
                  ),
                ),
                Marker(
                  markerId: const MarkerId('end'),
                  position: widget.session.routePoints.last,
                  icon: BitmapDescriptor.defaultMarkerWithHue(
                    BitmapDescriptor.hueRed,
                  ),
                ),
              ],
            },
            myLocationEnabled: false,
            myLocationButtonEnabled: false,
            zoomControlsEnabled: false,
            zoomGesturesEnabled: true,
            tiltGesturesEnabled: false,
            rotateGesturesEnabled: false,
          ),
          Positioned(
            top: buttonsTop,
            right: size.width * 0.05,
            child: Column(
              children: [
                GestureDetector(
                  onTap: _toggle3DMode,
                  child: Container(
                    width: 49,
                    height: 49,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _is3DMode ? TColors.primary : Colors.white,
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 5,
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                    child: Center(
                      child: Text(
                        _is3DMode ? '2D' : '3D',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: _is3DMode ? Colors.white : TColors.primary,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                GestureDetector(
                  onTap: _centerMapToRoute,
                  child: Container(
                    width: 48,
                    height: 48,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 5,
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                    child: const Icon(
                      Iconsax.direct_up,
                      color: TColors.primary,
                      size: 24,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                GestureDetector(
                  onTap: _zoomIn,
                  child: Container(
                    width: 48,
                    height: 48,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 5,
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.add,
                      color: TColors.primary,
                      size: 24,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                GestureDetector(
                  onTap: _zoomOut,
                  child: Container(
                    width: 48,
                    height: 48,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 5,
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.remove,
                      color: TColors.primary,
                      size: 24,
                    ),
                  ),
                ),
              ],
            ),
          ),
          DraggableScrollableSheet(
            initialChildSize: 0.15,
            minChildSize: 0.15,
            maxChildSize: 0.5,
            snap: true,
            builder: (BuildContext context, ScrollController scrollController) {
              return NotificationListener<DraggableScrollableNotification>(
                onNotification: (notification) {
                  setState(() {
                    _isExpanded = notification.extent > 0.2;
                  });
                  return true;
                },
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 10,
                        spreadRadius: 5,
                      ),
                    ],
                  ),
                  child: SingleChildScrollView(
                    controller: scrollController,
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(
                            child: Container(
                              width: 40,
                              height: 5,
                              margin: const EdgeInsets.only(top: 10),
                              decoration: BoxDecoration(
                                color: Colors.grey[300],
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          Row(
                            children: [
                              const Icon(
                                Icons.directions_run,
                                color: TColors.primary,
                                size: 24,
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      "Elapsed time",
                                      style: TextStyle(
                                        color: Colors.grey,
                                        fontSize: 14,
                                      ),
                                    ),
                                    Text(
                                      _formatTime(
                                        widget.session.elapsedTimeInSeconds,
                                      ),
                                      style: Theme.of(
                                        context,
                                      ).textTheme.bodyLarge?.copyWith(
                                        color: Colors.black,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      "Distance",
                                      style: TextStyle(
                                        color: Colors.grey,
                                        fontSize: 14,
                                      ),
                                    ),
                                    Text(
                                      "${widget.session.distanceInKm.toStringAsFixed(1)}km",
                                      style: Theme.of(
                                        context,
                                      ).textTheme.bodyLarge?.copyWith(
                                        color: Colors.black,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          if (_isExpanded) ...[
                            const SizedBox(height: 20),
                            const Text(
                              "Session Details",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 16),
                            _buildDetailRow(
                              "Steps",
                              "${widget.session.steps}",
                              Icons.directions_walk,
                            ),
                            const SizedBox(height: 16),
                            _buildDetailRow(
                              "Calories",
                              "${widget.session.calories.toStringAsFixed(0)} kcal",
                              Icons.local_fire_department,
                            ),
                            const SizedBox(height: 16),
                            _buildDetailRow(
                              "Date",
                              "${widget.session.date.day}/${widget.session.date.month}/${widget.session.date.year}",
                              Icons.calendar_today,
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: TColors.primary, size: 24),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(color: Colors.grey, fontSize: 14),
              ),
              Text(
                value,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
