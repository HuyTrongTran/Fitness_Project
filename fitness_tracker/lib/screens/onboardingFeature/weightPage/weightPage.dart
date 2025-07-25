import 'package:fitness_tracker/features/models/DetailPageButton.dart';
import 'package:fitness_tracker/features/models/DetailPageTitle.dart';
import 'package:fitness_tracker/features/models/user_onboarding_data.dart';
import 'package:fitness_tracker/api/apiUrl.dart';
import 'package:fitness_tracker/utils/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class WeightPage extends StatefulWidget {
  const WeightPage({super.key});

  @override
  State<WeightPage> createState() => _WeightPageState();
}

class _WeightPageState extends State<WeightPage> {
  double weight = 60.0;

  FixedExtentScrollController? _controller;
  late List<String> levels;

  @override
  void initState() {
    super.initState();
    // Tạo list từ 30kg đến 150kg, mỗi bước 0.5kg
    levels = List.generate(241, (i) => (30 + (i * 0.5)).toStringAsFixed(1));
    _controller = FixedExtentScrollController(
      initialItem: ((weight - 30) * 2).round(), // Điều chỉnh vị trí initial
    );
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  Future<void> _updateWeight(double weight) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('jwt_token');

    if (token == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No token found. Please log in again.')),
        // navigate to login page
      );
      Navigator.pushNamed(context, '/login');
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
        body: jsonEncode({'weight': weight}),
      );

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200 && responseData['success'] == true) {
        print('Weight updated successfully: $weight');
      } else {
        print('Failed to update weight: ${responseData['message']}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Failed to update weight: ${responseData['message']}',
            ),
          ),
        );
      }
    } catch (e) {
      print('Error occurred while updating weight: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('An error occurred while updating weight'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final UserOnboardingData data =
        ModalRoute.of(context)!.settings.arguments as UserOnboardingData;
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
                    title: "What is your weight?",
                    color: TColors.white,
                  ),
                  SizedBox(height: size.height * 0.12),
                  Text(
                    "${weight.toStringAsFixed(1)} kg",
                    style: Theme.of(
                      context,
                    ).textTheme.headlineLarge?.copyWith(color: Colors.white),
                  ),
                  SizedBox(
                    height: size.height * 0.2,
                    child: RotatedBox(
                      quarterTurns: -1,
                      child:
                          _controller == null
                              ? const SizedBox.shrink()
                              : ListWheelScrollView(
                                itemExtent: 4.0,
                                magnification: 1.1,
                                useMagnifier: true,
                                squeeze: 0.9,
                                overAndUnderCenterOpacity: 0.3,
                                physics: const FixedExtentScrollPhysics(),
                                controller: _controller!,
                                onSelectedItemChanged: (index) {
                                  setState(() {
                                    weight =
                                        30 +
                                        (index *
                                            0.5); // Cập nhật công thức tính weight
                                  });
                                },
                                children: List.generate(levels.length, (index) {
                                  bool isLongLine = index % 4 == 0;
                                  return RotatedBox(
                                    quarterTurns: 1,
                                    child: Container(
                                      width:
                                          isLongLine
                                              ? 1.5
                                              : 0.8, // Giảm độ dày của thanh
                                      height:
                                          isLongLine
                                              ? 30.0
                                              : 15.0, // Giảm chiều cao của thanh
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(
                                          0.5,
                                        ), // Bo góc nhỏ hơn
                                      ),
                                    ),
                                  );
                                }),
                              ),
                    ),
                  ),
                  SizedBox(height: size.height * 0.19),
                  DetailPageButton(
                    text: "Next",
                    onTap: () async {
                      // Lưu weight vào UserOnboardingData
                      data.weight = weight;
                      print("Selected weight: $weight");

                      // Gọi API để cập nhật weight vào database
                      await _updateWeight(weight);

                      // Chuyển đến trang tiếp theo
                      Navigator.pushNamed(context, '/goal', arguments: data);
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
