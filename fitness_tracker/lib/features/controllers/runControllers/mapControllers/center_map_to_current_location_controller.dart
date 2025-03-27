import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

class CenterMapToCurrentLocationController {
  Future<void> centerMapToCurrentLocation({
    required GoogleMapController? mapController,
    required Position? currentPosition,
    required double currentZoom,
    required bool is3DMode,
  }) async {
    if (currentPosition != null) {
      mapController?.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: LatLng(currentPosition.latitude, currentPosition.longitude),
            zoom: currentZoom,
            tilt: is3DMode ? 45 : 0,
          ),
        ),
      );
    }
  }
}