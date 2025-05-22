
class ZoomOutController {
  void zoomOut({
    required double currentZoom,
    required Function(double) onZoomChanged,
    required Function centerMapCallback,
  }) {
    if (currentZoom > 10) {
      onZoomChanged(currentZoom - 1);
      centerMapCallback();
    }
  }
}