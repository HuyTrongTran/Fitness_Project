import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:iconsax/iconsax.dart';
import 'package:fitness_tracker/utils/constants/colors.dart';
import 'package:fitness_tracker/runFeature/runTrackingScreen/controllers/mapControllers/create_marker_icons_controller.dart';
import 'package:fitness_tracker/runFeature/runTrackingScreen/controllers/locationControllers/request_location_permission_controller.dart';
import 'package:fitness_tracker/runFeature/runTrackingScreen/controllers/locationControllers/update_current_location_marker_controller.dart';
import 'package:fitness_tracker/runFeature/runTrackingScreen/controllers/trackingControllers/start_tracking_controller.dart';
import 'package:fitness_tracker/runFeature/runTrackingScreen/controllers/mapControllers/center_map_to_current_location_controller.dart';
import 'package:fitness_tracker/runFeature/runTrackingScreen/controllers/mapControllers/toggle_3d_mode_controller.dart';
import 'package:fitness_tracker/runFeature/runTrackingScreen/controllers/mapControllers/zoom_in_controller.dart';
import 'package:fitness_tracker/runFeature/runTrackingScreen/controllers/mapControllers/zoom_out_controller.dart';
import 'package:fitness_tracker/runFeature/runTrackingScreen/controllers/mapControllers/calculate_distance_controller.dart';
import 'package:fitness_tracker/runFeature/runTrackingScreen/controllers/trackingControllers/start_timer_controller.dart';
import 'package:fitness_tracker/runFeature/runTrackingScreen/controllers/trackingControllers/stop_tracking_controller.dart';

class RunTrackingPage extends StatefulWidget {
  const RunTrackingPage({super.key});

  @override
  _RunTrackingPageState createState() => _RunTrackingPageState();
}

class _RunTrackingPageState extends State<RunTrackingPage> {
  GoogleMapController? _mapController;
  Position? _currentPosition;
  List<LatLng> _routePoints = [];
  int _elapsedTimeInSeconds = 0;
  double _distanceInKm = 0.0;
  Set<Marker> _markers = {};
  bool _isExpanded = false;
  bool _is3DMode = false;
  BitmapDescriptor? _smallMarkerIcon;
  BitmapDescriptor? _largeMarkerIcon;
  double _currentZoom = 18.0;

  static const LatLng _initialPosition = LatLng(10.7769, 106.7009);

  late final CreateMarkerIconsController _createMarkerIconsController;
  late final RequestLocationPermissionController _requestLocationPermissionController;
  late final UpdateCurrentLocationMarkerController _updateCurrentLocationMarkerController;
  late final StartTrackingController _startTrackingController;
  late final CenterMapToCurrentLocationController _centerMapToCurrentLocationController;
  late final Toggle3DModeController _toggle3DModeController;
  late final ZoomInController _zoomInController;
  late final ZoomOutController _zoomOutController;
  late final CalculateDistanceController _calculateDistanceController;
  late final StartTimerController _startTimerController;
  late final StopTrackingController _stopTrackingController;

  @override
  void initState() {
    super.initState();
    _createMarkerIconsController = CreateMarkerIconsController();
    _requestLocationPermissionController = RequestLocationPermissionController();
    _updateCurrentLocationMarkerController = UpdateCurrentLocationMarkerController();
    _startTrackingController = StartTrackingController();
    _centerMapToCurrentLocationController = CenterMapToCurrentLocationController();
    _toggle3DModeController = Toggle3DModeController();
    _zoomInController = ZoomInController();
    _zoomOutController = ZoomOutController();
    _calculateDistanceController = CalculateDistanceController();
    _startTimerController = StartTimerController();
    _stopTrackingController = StopTrackingController();

    _createMarkerIconsController.createMarkerIcons(
      onIconsCreated: (small, large) {
        if (mounted) {
          setState(() {
            _smallMarkerIcon = small;
            _largeMarkerIcon = large;
          });
        }
      },
      updateMarkerCallback: (position) => _updateCurrentLocationMarkerController.updateCurrentLocationMarker(
        mapController: _mapController,
        position: position,
        smallMarkerIcon: _smallMarkerIcon,
        largeMarkerIcon: _largeMarkerIcon,
        isExpanded: _isExpanded,
        currentZoom: _currentZoom,
        is3DMode: _is3DMode,
        onMarkersUpdated: (markers) => setState(() => _markers = markers),
      ),
      currentPosition: _currentPosition,
    );

    _requestLocationPermissionController.requestLocationPermission(context, () {
      _startTrackingController.startTracking(
        onPointAdded: (point) {
          if (mounted) {
            setState(() {
              _routePoints.add(point);
              if (_routePoints.length > 200) {
                _routePoints.removeRange(0, _routePoints.length - 200);
              }
            });
          }
        },
        onDistanceUpdated: (distance) {
          if (mounted) {
            setState(() => _distanceInKm = _calculateDistanceController.calculateDistance(_routePoints));
          }
        },
        onPositionUpdated: (position) {
          if (mounted) {
            setState(() => _currentPosition = position);
            _updateCurrentLocationMarkerController.updateCurrentLocationMarker(
              mapController: _mapController,
              position: position,
              smallMarkerIcon: _smallMarkerIcon,
              largeMarkerIcon: _largeMarkerIcon,
              isExpanded: _isExpanded,
              currentZoom: _currentZoom,
              is3DMode: _is3DMode,
              onMarkersUpdated: (markers) => setState(() => _markers = markers),
            );
          }
        },
        context: context,
      );
    });

    _startTimerController.startTimer((time) {
      if (mounted) {
        setState(() => _elapsedTimeInSeconds = time);
      }
    });
  }

  @override
  void dispose() {
    _startTimerController.dispose();
    _startTrackingController.dispose();
    _mapController?.dispose();
    super.dispose();
  }

  String _formatTime(int seconds) {
    int hours = seconds ~/ 3600;
    int minutes = (seconds % 3600) ~/ 60;
    int secs = seconds % 60;
    return "${hours > 0 ? '${hours.toString().padLeft(2, '0')}:' : ''}${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}";
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    double navbarHeight = _isExpanded ? size.height * 0.5 : size.height * 0.15;
    double buttonsTop = _isExpanded ? (size.height * 0.5 - 220) : size.height * 0.4;

    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: _initialPosition,
              zoom: _currentZoom,
              tilt: _is3DMode ? 45 : 0,
            ),
            onMapCreated: (GoogleMapController controller) {
              _mapController = controller;
              if (_currentPosition != null) {
                _centerMapToCurrentLocationController.centerMapToCurrentLocation(
                  mapController: _mapController,
                  currentPosition: _currentPosition,
                  currentZoom: _currentZoom,
                  is3DMode: _is3DMode,
                );
              }
            },
            markers: _markers,
            polylines: {
              Polyline(
                polylineId: const PolylineId('route'),
                points: _routePoints,
                color: Colors.blue,
                width: 5,
                patterns: [PatternItem.dash(10), PatternItem.gap(10)],
              ),
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
                  onTap: () => _toggle3DModeController.toggle3DMode(
                    is3DMode: _is3DMode,
                    onModeChanged: (mode) => setState(() => _is3DMode = mode),
                    centerMapCallback: () => _centerMapToCurrentLocationController.centerMapToCurrentLocation(
                      mapController: _mapController,
                      currentPosition: _currentPosition,
                      currentZoom: _currentZoom,
                      is3DMode: _is3DMode,
                    ),
                  ),
                  child: Container(
                    width: 49,
                    height: 49,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _is3DMode ? TColors.primary : Colors.white,
                      boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 5, spreadRadius: 1)],
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
                  onTap: () => _centerMapToCurrentLocationController.centerMapToCurrentLocation(
                    mapController: _mapController,
                    currentPosition: _currentPosition,
                    currentZoom: _currentZoom,
                    is3DMode: _is3DMode,
                  ),
                  child: Container(
                    width: 48,
                    height: 48,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                      boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 5, spreadRadius: 1)],
                    ),
                    child: const Icon(Iconsax.direct_up, color: TColors.primary, size: 24),
                  ),
                ),
                const SizedBox(height: 10),
                GestureDetector(
                  onTap: () => _zoomInController.zoomIn(
                    currentZoom: _currentZoom,
                    onZoomChanged: (zoom) => setState(() => _currentZoom = zoom),
                    centerMapCallback: () => _centerMapToCurrentLocationController.centerMapToCurrentLocation(
                      mapController: _mapController,
                      currentPosition: _currentPosition,
                      currentZoom: _currentZoom,
                      is3DMode: _is3DMode,
                    ),
                  ),
                  child: Container(
                    width: 48,
                    height: 48,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                      boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 5, spreadRadius: 1)],
                    ),
                    child: const Icon(Icons.add, color: TColors.primary, size: 24),
                  ),
                ),
                const SizedBox(height: 10),
                GestureDetector(
                  onTap: () => _zoomOutController.zoomOut(
                    currentZoom: _currentZoom,
                    onZoomChanged: (zoom) => setState(() => _currentZoom = zoom),
                    centerMapCallback: () => _centerMapToCurrentLocationController.centerMapToCurrentLocation(
                      mapController: _mapController,
                      currentPosition: _currentPosition,
                      currentZoom: _currentZoom,
                      is3DMode: _is3DMode,
                    ),
                  ),
                  child: Container(
                    width: 48,
                    height: 48,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                      boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 5, spreadRadius: 1)],
                    ),
                    child: const Icon(Icons.remove, color: TColors.primary, size: 24),
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
                  if (mounted) {
                    setState(() {
                      _isExpanded = notification.extent > 0.2;
                      if (_currentPosition != null) {
                        _updateCurrentLocationMarkerController.updateCurrentLocationMarker(
                          mapController: _mapController,
                          position: _currentPosition!,
                          smallMarkerIcon: _smallMarkerIcon,
                          largeMarkerIcon: _largeMarkerIcon,
                          isExpanded: _isExpanded,
                          currentZoom: _currentZoom,
                          is3DMode: _is3DMode,
                          onMarkersUpdated: (markers) => setState(() => _markers = markers),
                        );
                      }
                    });
                  }
                  return true;
                },
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
                    boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10, spreadRadius: 5)],
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
                              decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(10)),
                            ),
                          ),
                          if (!_isExpanded) ...[
                            Row(
                              children: [
                                const Icon(Icons.directions_run, color: TColors.primary, size: 24),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Text("Elapsed time", style: TextStyle(color: Colors.grey, fontSize: 14)),
                                      Text(
                                        _formatTime(_elapsedTimeInSeconds),
                                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
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
                                      const Text("Distance", style: TextStyle(color: Colors.grey, fontSize: 14)),
                                      Text(
                                        "${_distanceInKm.toStringAsFixed(1)}km",
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
                            ),
                          ],
                          if (_isExpanded) ...[
                            const Text(
                              "Your run session",
                              style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 16),
                            Row(
                              children: [
                                const Icon(Icons.directions_run, color: TColors.primary, size: 24),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Text("Elapsed time", style: TextStyle(color: Colors.grey, fontSize: 14)),
                                      Text(
                                        _formatTime(_elapsedTimeInSeconds),
                                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
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
                                      const Text("Distance", style: TextStyle(color: Colors.grey, fontSize: 14)),
                                      Text(
                                        "${_distanceInKm.toStringAsFixed(1)}km",
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
                            ),
                            const SizedBox(height: 16),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: () => _stopTrackingController.stopTracking(
                                  context: context,
                                  elapsedTimeInSeconds: _elapsedTimeInSeconds,
                                  distanceInKm: _distanceInKm,
                                  routePoints: _routePoints,
                                  onStop: () {
                                    _startTimerController.dispose();
                                    _startTrackingController.dispose();
                                  },
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: TColors.primary,
                                  padding: const EdgeInsets.symmetric(vertical: 15),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                ),
                                child: const Text(
                                  "Stop",
                                  style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                            const Text(
                              "Last session",
                              style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              "Last time results: 7.12 km",
                              style: TextStyle(color: Colors.grey, fontSize: 14),
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
}