
class ZoomInController {
  void zoomIn({
    required double currentZoom,
    required Function(double) onZoomChanged,
    required Function centerMapCallback,
  }) {
    if (currentZoom < 20) {
      onZoomChanged(currentZoom + 1);
      centerMapCallback();
    }
  }
}