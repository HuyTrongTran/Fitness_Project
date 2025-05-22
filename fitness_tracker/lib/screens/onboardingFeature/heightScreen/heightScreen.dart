import 'package:fitness_tracker/features/models/DetailPageButton.dart';
import 'package:fitness_tracker/features/models/DetailPageTitle.dart';
import 'package:fitness_tracker/features/models/ListWheelViewScroller.dart';
import 'package:fitness_tracker/features/models/user_onboarding_data.dart';
import 'package:fitness_tracker/api/apiUrl.dart';
import 'package:fitness_tracker/utils/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class HeightPage extends StatefulWidget {
  const HeightPage({super.key});

  @override
  State<HeightPage> createState() => _HeightPageState();
}

class _HeightPageState extends State<HeightPage> {
  double selectedHeight = 160;

  Future<void> _updateHeight(double height) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('jwt_token');

    if (token == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No token found. Please log in again.')),
      );
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
        body: jsonEncode({'height': height}),
      );

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200 && responseData['success'] == true) {
        print('Height updated successfully: $height');
      } else {
        print('Failed to update height: ${responseData['message']}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Failed to update height: ${responseData['message']}',
            ),
          ),
        );
      }
    } catch (e) {
      print('Error occurred while updating height: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('An error occurred while updating height'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final UserOnboardingData data =
        ModalRoute.of(context)!.settings.arguments as UserOnboardingData;
    List<String> items = [];
    for (int i = 1; i <= 200; i++) {
      items.add("$i cm");
    }
    var size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: TColors.light,
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
            Positioned.fill(
              child: Image.asset(
                'assets/images/background.png',
                fit: BoxFit.cover,
              ),
            ),
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
                    text: "This helps us to create a personalized plan for you",
                    title: "What is your height?",
                    color: TColors.white,
                  ),
                  SizedBox(height: size.height * 0.055),
                  SizedBox(
                    height: size.height * 0.5,
                    child: Listwheelviewscroller(
                      initialItem: 160,
                      items: items,
                      onSelectedItemChanged: (index) {
                        setState(() {
                          selectedHeight = double.parse(
                            items[index].split(' ')[0],
                          );
                        });
                      },
                    ),
                  ),
                  DetailPageButton(
                    text: "Next",
                    onTap: () async {
                      // Lưu height vào UserOnboardingData
                      data.height = selectedHeight;
                      print("Selected height: $selectedHeight");

                      // Gọi API để cập nhật height vào database
                      await _updateHeight(selectedHeight);

                      // Chuyển đến trang tiếp theo
                      Navigator.pushNamed(context, '/weight', arguments: data);
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
