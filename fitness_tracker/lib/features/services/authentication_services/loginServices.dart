import 'package:fitness_tracker/common/widgets/custome_shape/custome_snackbar/customSnackbar.dart';
import 'package:fitness_tracker/features/services/home_services/recent_plan/suggestCheck.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class LoginService {
  Future<void> signInWithGoogle(BuildContext context) async {
    try {
      showCustomSnackbar(
        'Processing',
        'Đang xử lý đăng nhập...',
        type: SnackbarType.processing,
      );
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) {
        showCustomSnackbar(
          'Error',
          'Đăng nhập bị hủy',
          type: SnackbarType.error,
        );
        return;
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential = await FirebaseAuth.instance.signInWithCredential(
        credential,
      );
      final user = userCredential.user;

      if (user != null) {
        final idToken = await user.getIdToken();
        print('Google ID Token: $idToken'); // In token ra console

        final userData = {
          'uid': user.uid,
          'email': user.email ?? '',
          'firstName': user.displayName?.split(' ').first ?? '',
          'lastName': user.displayName?.split(' ').skip(1).join(' ') ?? '',
          'username': user.email?.split('@').first ?? '',
          'password': "111111",
        };
  

        await _syncUserToMongoDB(userData, idToken!, context);
        showCustomSnackbar(
          'Success',
          'Đăng nhập Google thành công',
          type: SnackbarType.success,
        );

        await checkAndNavigate(context);
      }
    } catch (e) {
      print('Lỗi đăng nhập Google: $e');
    }
  }

  Future<void> signInWithFacebook(BuildContext context) async {
    try {
      showCustomSnackbar(
        'Processing',
        'Đang xử lý đăng nhập...',
        type: SnackbarType.processing,
      );
      final LoginResult result = await FacebookAuth.instance.login();
      if (result.status != LoginStatus.success) {
        showCustomSnackbar(
          'Error',
          'Đăng nhập bị hủy',
          type: SnackbarType.error,
        );
        return;
      }

      final OAuthCredential credential = FacebookAuthProvider.credential(
        result.accessToken!.tokenString,
      );
      final userCredential = await FirebaseAuth.instance.signInWithCredential(
        credential,
      );
      final user = userCredential.user;

      if (user != null) {
        final idToken = await user.getIdToken();
        print('Facebook ID Token: $idToken'); // In token ra console
        showCustomSnackbar(
          'Success',
          'Token: $idToken',
          type: SnackbarType.success,
        ); // Hiển thị token qua snackbar

        final userData = {
          'uid': user.uid,
          'email': user.email ?? '',
          'firstName': user.displayName?.split(' ').first ?? '',
          'lastName': user.displayName?.split(' ').skip(1).join(' ') ?? '',
          'username': user.email?.split('@').first ?? '',
        };

        await _syncUserToMongoDB(userData, idToken!, context);
        showCustomSnackbar(
          'Success',
          'Đăng nhập Facebook thành công',
          type: SnackbarType.success,
        );
      }
    } catch (e) {
      showCustomSnackbar(
        'Error',
        'Lỗi đăng nhập Facebook: $e',
        type: SnackbarType.error,
      );
    }
  }

  Future<void> _syncUserToMongoDB(
    Map<String, String> userData,
    String idToken,
    BuildContext context,
  ) async {
    try {
      showCustomSnackbar(
        'Processing',
        'Đang đồng bộ dữ liệu...',
        type: SnackbarType.processing,
      );
      final response = await http.post(
        Uri.parse('http://localhost:3000/api/register'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(userData),
      );

      final responseData = jsonDecode(response.body);
      if (response.statusCode == 200) {
        showCustomSnackbar(
          'Success',
          'Đồng bộ dữ liệu thành công',
          type: SnackbarType.success,
        );
        // Optionally store JWT token from responseData['data']['token']
      } else {
        showCustomSnackbar(
          'Error',
          'Lỗi đồng bộ: ${responseData['message']}',
          type: SnackbarType.error,
        );
      }
    } catch (e) {
      showCustomSnackbar('Error', 'Lỗi đồng bộ: $e', type: SnackbarType.error);
    }
  }
}
