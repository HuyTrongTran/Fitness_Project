import 'package:fitness_tracker/models/DetailPageButton.dart';
import 'package:fitness_tracker/models/DetailPageTitle.dart';
import 'package:fitness_tracker/models/user_onboarding_data.dart';
import 'package:fitness_tracker/api/apiUrl.dart';
import 'package:flutter/material.dart';
import '../../../utils/constants/colors.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class GenderPage extends StatefulWidget {
  const GenderPage({super.key});

  @override
  State<GenderPage> createState() => _GenderPageState();
}

class _GenderPageState extends State<GenderPage> {
  bool isMale = true;
  bool isFemale = false;
  bool _isLoading = false;

  Future<void> _updateGender(String gender) async {
    setState(() {
      _isLoading = true;
    });

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('jwt_token');

    if (token == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No token found. Please log in again.')),
      );
      setState(() {
        _isLoading = false;
      });
      return;
    }

    const String apiUrl = '${ApiConfig.baseUrl}/update-profile';

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({'gender': gender}),
      );

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200 && responseData['success'] == true) {
        print('Gender updated successfully: $gender');
      } else {
        print('Failed to update gender: ${responseData['message']}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Failed to update gender: ${responseData['message']}',
            ),
          ),
        );
      }
    } catch (e) {
      print('Error occurred while updating gender: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('An error occurred while updating gender'),
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        width: size.width,
        height: size.height,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF4A90E2), // Màu xanh lam nhạt
              Color(0xFF4A90E2), // Màu xanh lam đậm
            ],
          ),
        ),
        child: Stack(
          children: [
            // Background image
            Positioned.fill(
              child: Image.asset(
                'assets/images/background.png',
                fit: BoxFit.cover,
              ),
            ),
            // Main content
            Padding(
              padding: EdgeInsets.only(
                top: size.height * 0.06,
                left: size.width * 0.05,
                right: size.width * 0.05,
                bottom: size.height * 0.03,
              ),
              child: Column(
                children: [
                  const Detailpagetitle(
                    title: "Tell Us About Yourself",
                    text:
                        "This will help us to find the best \n content for you",
                    color: Colors.white, // Đổi màu thành trắng
                  ),
                  SizedBox(height: size.height * 0.02),
                  GenderIcon(
                    icon: Icons.male,
                    title: 'Male',
                    onTap: () {
                      setState(() {
                        isMale = true;
                        isFemale = false;
                      });
                    },
                    isSelected: isMale,
                  ),
                  SizedBox(height: size.height * 0.05),
                  GenderIcon(
                    icon: Icons.female,
                    title: 'Female',
                    onTap: () {
                      setState(() {
                        isMale = false;
                        isFemale = true;
                      });
                    },
                    isSelected: isFemale,
                  ),
                  SizedBox(height: size.height * 0.2),
                  DetailPageButton(
                    text: "Next",
                    onTap: () async {
                      // Xác định gender
                      final String gender = isMale ? 'male' : 'female';

                      // Lưu gender vào UserOnboardingData
                      final data = UserOnboardingData(gender: gender);
                      print("Selected gender: $gender");

                      // Gọi API để cập nhật gender vào database
                      await _updateGender(gender);

                      // Chuyển đến trang tiếp theo
                      Navigator.pushNamed(context, '/age', arguments: data);
                    },
                    showBackButton: true,
                    onBackTap: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class GenderIcon extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;
  final bool isSelected;

  const GenderIcon({
    super.key,
    required this.icon,
    required this.title,
    required this.onTap,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    final double circleSize = size.width * 0.3;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: circleSize,
        height: circleSize,
        padding: EdgeInsets.all(size.width * 0.05),
        decoration: BoxDecoration(
          color:
              isSelected ? Colors.white : TColors.primary, // Nền khi được chọn
          shape: BoxShape.circle,
          border: Border.all(
            color: Colors.white, // Viền trắng
            width: 2.0,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: size.width * 0.09,
              color:
                  isSelected
                      ? TColors.primary
                      : Colors.white, // Biểu tượng màu trắng
            ),
            SizedBox(height: size.height * 0.01),
            Text(
              title,
              style: TextStyle(
                color:
                    isSelected
                        ? TColors.primary
                        : TColors.white, // Text màu trắng
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
