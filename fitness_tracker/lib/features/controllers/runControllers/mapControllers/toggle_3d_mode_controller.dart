
class Toggle3DModeController {
  void toggle3DMode({
    required bool is3DMode,
    required Function(bool) onModeChanged,
    required Function centerMapCallback,
  }) {
    onModeChanged(!is3DMode);
    centerMapCallback();
  }
}