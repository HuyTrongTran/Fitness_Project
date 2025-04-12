import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fitness_tracker/api/apiUrl.dart';

class UpdateProfileService {
  static Future<bool> updateProfile({
    required String userName,
    File? image,
  }) async {
    try {
      final token = await SharedPreferences.getInstance().then(
        (prefs) => prefs.getString('jwt_token'),
      );
      if (token == null) {
        throw Exception('Token not found');
      }

      // Tạo multipart request
      final request = http.MultipartRequest(
        'POST',
        Uri.parse('${ApiConfig.baseUrl}/api/user/update-profile'),
      );

      // Thêm headers
      request.headers['Authorization'] = 'Bearer $token';

      // Thêm các trường dữ liệu
      request.fields['userName'] = userName;

      // Nếu có ảnh, thêm vào request
      if (image != null) {
        // Kiểm tra loại file
        final fileExtension = image.path.split('.').last.toLowerCase();
        if (!['jpg', 'jpeg', 'png'].contains(fileExtension)) {
          throw Exception('Allowed file types: JPG, JPEG, PNG');
        }
        request.files.add(
          await http.MultipartFile.fromPath('image', image.path),
        );
      }
      final response = await request.send();

      final responseData = await response.stream.bytesToString();

      final jsonResponse = json.decode(responseData);

      if (response.statusCode == 200 && jsonResponse['success'] == true) {
        return true;
      } else {
        throw Exception(jsonResponse['message'] ?? 'Failed to update profile');
      }
    } catch (e) {
      print('Error updating profile: $e');
      return false;
    }
  }

  static Future<bool> uploadProfileImage(File image) async {
    try {
      // Kiểm tra loại file
      final fileExtension = image.path.split('.').last.toLowerCase();
      if (!['jpg', 'jpeg', 'png'].contains(fileExtension)) {
        throw Exception('Allowed file types: JPG, JPEG, PNG');
      }

      // Xác định MIME type
      String mimeType;
      switch (fileExtension) {
        case 'jpg':
        case 'jpeg':
          mimeType = 'image/jpeg';
          break;
        case 'png':
          mimeType = 'image/png';
          break;
        default:
          mimeType = 'image/jpeg';
      }

      final token = await SharedPreferences.getInstance().then(
        (prefs) => prefs.getString('jwt_token'),
      );
      if (token == null) {
        throw Exception('Token not found');
      }

      final request = http.MultipartRequest(
        'POST',
        Uri.parse('${ApiConfig.baseUrl}/upload-profile-image'),
      );

      request.headers['Authorization'] = 'Bearer $token';

      // Thêm file với MIME type cụ thể
      request.files.add(
        await http.MultipartFile.fromPath(
          'image',
          image.path,
          contentType: MediaType.parse(mimeType),
        ),
      );

      final response = await request.send();

      final responseData = await response.stream.bytesToString();

      final jsonResponse = json.decode(responseData);

      if (response.statusCode == 200 && jsonResponse['success'] == true) {
        return true;
      } else {
        throw Exception(jsonResponse['message'] ?? 'Failed to upload image');
      }
    } catch (e) {
      print('Error while uploading image: $e');
      return false;
    }
  }

  static Future<bool> updateUserInfo({required String userName}) async {
    try {
      final token = await SharedPreferences.getInstance().then(
        (prefs) => prefs.getString('jwt_token'),
      );
      if (token == null) {
        throw Exception('Token not found');
      }

      final response = await http.post(
        Uri.parse('${ApiConfig.baseUrl}/update-user-info'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode({'userName': userName}),
      );

      final responseData = json.decode(response.body);
      if (response.statusCode == 200 && responseData['success'] == true) {
        return true;
      } else {
        throw Exception(
          responseData['message'] ?? 'Failed to update user info',
        );
      }
    } catch (e) {
      print('Error updating user info: $e');
      return false;
    }
  }
}
