import 'package:fitness_tracker/common/widgets/appbar/appbar.dart';
import 'package:fitness_tracker/common/widgets/custome_shape/containers/circular_container.dart';
import 'package:fitness_tracker/common/widgets/custome_shape/containers/circular_image.dart';
import 'package:fitness_tracker/common/widgets/custome_shape/containers/primary_header_container.dart';
import 'package:fitness_tracker/common/widgets/texts/section_heading.dart';
import 'package:fitness_tracker/screens/settings/widgets/setting_menu_title.dart';
import 'package:fitness_tracker/screens/settings/widgets/user_profile_title.dart';
import 'package:fitness_tracker/utils/constants/colors.dart';
import 'package:fitness_tracker/screens/Login/login.dart';
import 'package:fitness_tracker/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class Settings extends StatelessWidget {
  const Settings({super.key});

  static Future<void> _logout() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('jwt_token');

    if (token != null) {
      try {
        const String apiUrl = 'http://10.0.2.2:3000/api/logout';
        final response = await http.post(
          Uri.parse(apiUrl),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
        );

        if (response.statusCode == 200) {
          print('Logout successful on server');
        } else {
          print('Logout failed on server: ${response.body}');
        }
      } catch (e) {
        print('Error during logout: $e');
      }
    }

    // Xóa token và email ở client
    await prefs.remove('jwt_token');
    await prefs.remove('user_email');
    Get.offAll(() => const Login());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            PrimaryHeaderContainer(
              child: Column(
                children: [
                  TAppBar(
                    title: Text(
                      "Account",
                      style: Theme.of(context)
                          .textTheme
                          .headlineMedium!
                          .apply(color: TColors.white),
                    ),
                  ),
                  const UserProfileTitle(
                    name: "John Doe",
                    email: "john.doe@example.com",
                  ),
                  const SizedBox(height: TSizes.spaceBtwSections),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(TSizes.defaultSpace),
              child: Column(
                children: [
                  SectionHeading(title: 'Account Settings', onPressed: () {}),
                  const SizedBox(height: TSizes.spaceBtwItems),
                  SettingMenuTitle(
                    icon: Iconsax.notification,
                    title: "Notifications",
                    subTitle: "Set notifications preferences",
                    onTap: () {},
                  ),
                  SettingMenuTitle(
                    icon: Iconsax.key,
                    title: "Change Password",
                    subTitle: "Change your password",
                    onTap: () {},
                  ),
                  SettingMenuTitle(
                    icon: Iconsax.logout,
                    title: "Logout",
                    subTitle: "Logout from your account",
                    onTap: () {
                      Get.defaultDialog(
                        title: 'Đăng xuất',
                        middleText: 'Bạn có chắc muốn đăng xuất?',
                        textConfirm: 'Có',
                        textCancel: 'Không',
                        confirmTextColor: Colors.white,
                        onConfirm: () async {
                          await _logout();
                        },
                        onCancel: () {
                          Get.back();
                        },
                      );
                    },
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