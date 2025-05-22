import 'package:fitness_tracker/utils/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:fitness_tracker/screens/runSessionFeature/runResult/RunResultPage.dart';
import 'package:fitness_tracker/screens/runSessionFeature/runResult/controllers/runSession.dart';
import 'package:fitness_tracker/features/services/run_services/run_history_service.dart';
import 'package:flutter/foundation.dart';

class StopTrackingController {
  static Future<void> stopTracking(
    BuildContext context,
    RunSession session,
  ) async {
    try {
      // Hiển thị loading dialog
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return const Center(child: CircularProgressIndicator(
            color: TColors.primary,
          ));
        },
      );

      // Gửi dữ liệu lên server
      final success = await RunHistoryService.submitRunSession(session);

      // Đóng loading dialog
      Navigator.pop(context);

      if (success) {
        // Lưu session vào local storage
        RunSessionManager.addSession(session);

        // Chuyển đến trang kết quả
        if (context.mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => RunResultPage(session: session),
            ),
          );
        }
      } else {
        throw Exception('Failed to save run session');
      }
    } catch (e) {
      // Đóng loading dialog nếu có
      if (context.mounted) {
        Navigator.pop(context);
      }

      debugPrint('Error saving run session: $e');

      // Hiển thị thông báo lỗi phù hợp
      String errorMessage = 'An error occurred while saving run session';
      if (e is Exception) {
        errorMessage = e.toString();
      }

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorMessage), backgroundColor: Colors.red),
        );
      }
    }
  }
}
