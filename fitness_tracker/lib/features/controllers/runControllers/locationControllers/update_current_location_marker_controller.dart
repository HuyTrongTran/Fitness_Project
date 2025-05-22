import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

class UpdateCurrentLocationMarkerController {
  Future<void> updateCurrentLocationMarker({
    required GoogleMapController? mapController,
    required Position position,
    required BitmapDescriptor? smallMarkerIcon,
    required BitmapDescriptor? largeMarkerIcon,
    required bool isExpanded,
    required double currentZoom,
    required bool is3DMode,
    required Function(Set<Marker>) onMarkersUpdated,
  }) async {
    if (smallMarkerIcon == null || largeMarkerIcon == null) return;

    final markers = <Marker>{
      Marker(
        markerId: const MarkerId('current_location'),
        position: LatLng(position.latitude, position.longitude),
        icon: isExpanded ? largeMarkerIcon : smallMarkerIcon,
      ),
    };

    onMarkersUpdated(markers);

    mapController?.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(position.latitude, position.longitude),
          zoom: currentZoom,
          tilt: is3DMode ? 45 : 0,
        ),
      ),
    );
  }
}