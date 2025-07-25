import 'package:flutter/material.dart';
import 'package:get/get.dart';

// Enum để xác định loại snackbar
enum SnackbarType { success, error, processing }

// Hàm hiển thị snackbar tùy chỉnh
void showCustomSnackbar(
  String title,
  String message, {
  required SnackbarType type,
}) {
  // Xác định màu nền và icon dựa trên loại snackbar
  Color backgroundColor;
  IconData icon;

  switch (type) {
    case SnackbarType.success:
      backgroundColor = Colors.green;
      icon = Icons.check_circle;
      break;
    case SnackbarType.error:
      backgroundColor = Colors.red; // Giả định TColors.error là màu đỏ
      icon = Icons.error;
      break;
    case SnackbarType.processing:
      backgroundColor = Colors.orange; // Giả định TColors.warning là màu cam
      icon = Icons.hourglass_empty;
      break;
  }

  Get.snackbar(
    title,
    message,
    // Tùy chỉnh tiêu đề
    titleText: Text(
      title,
      style: const TextStyle(
        color: Colors.white,
        fontFamily: 'Nunito',
        fontWeight: FontWeight.bold,
        fontSize: 16,
      ),
    ),
    // Tùy chỉnh nội dung
    messageText: Text(
      message,
      style: const TextStyle(
        color: Colors.white,
        fontFamily: 'Nunito',
        fontSize: 14,
      ),
    ),
    // Màu nền
    backgroundColor: backgroundColor,
    // Thời gian hiển thị
    duration: const Duration(seconds: 3),
    // Vị trí snackbar
    snackPosition: SnackPosition.TOP,
    // Border radius
    borderRadius: 12,
    // Khoảng cách từ mép màn hình
    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
    // Hiệu ứng chuyển động
    animationDuration: const Duration(milliseconds: 500),
    // Bóng đổ
    boxShadows: [
      BoxShadow(
        color: Colors.black.withOpacity(0.5),
        blurRadius: 8,
        offset: const Offset(0, 2),
      ),
    ],
    // Icon
    icon: Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.18),
        shape: BoxShape.circle,
      ),
      child: Center(child: Icon(icon, color: Colors.white, size: 20)),
    ),
    // Khoảng cách giữa icon và nội dung
    padding: const EdgeInsets.only(left: 28, right: 16, top: 12, bottom: 12),
  );
}

// // Ví dụ sử dụng
// void main() {
//   // Success snackbar
//   showCustomSnackbar('Success', 'Registration successful! Please log in.', type: SnackbarType.success);

//   // Error snackbar
//   showCustomSnackbar('Error', 'Failed to register. Email already exists.', type: SnackbarType.error);

//   // Processing snackbar
//   showCustomSnackbar('Processing', 'Please wait while we process your request...', type: SnackbarType.processing);
// }
