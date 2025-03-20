import 'package:fitness_tracker/navigation_menu.dart';
import 'package:fitness_tracker/screens/password_configuration/forget_password.dart';
import 'package:fitness_tracker/screens/signup.widgets/signup.dart';
import 'package:fitness_tracker/screens/OnBoardingScreen/onboardingScreen.dart';
import 'package:fitness_tracker/utils/constants/sizes.dart';
import 'package:fitness_tracker/utils/constants/text_strings.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _rememberMe = false;
  bool _isPasswordVisible = false;
  bool _showLoginError = false;

  final _emailPattern = RegExp(
    r'^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+',
    caseSensitive: false,
  );

  Future<void> _login() async {
    setState(() {
      _isLoading = true;
      _showLoginError = false;
    });

    if (!_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = false;
      });
      return;
    }

    final String email = _emailController.text.trim();
    final String password = _passwordController.text.trim();

    const String apiUrl = 'http://10.0.2.2:3000/api/login';

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({'email': email, 'password': password}),
      );

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200 && responseData['success'] == true) {
        final token = responseData['data']['token'];
        final profile = responseData['data']['profile'];

        // Lưu token và email vào SharedPreferences
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('jwt_token', token);
        await prefs.setString('user_email', email); // Lưu email để phân biệt tài khoản

        // Kiểm tra trạng thái onboarding dựa trên email
        final onboardingKey = 'has_completed_onboarding_$email';
        final hasCompletedOnboarding = prefs.getBool(onboardingKey) ?? false;

        if (hasCompletedOnboarding) {
          Get.offAll(() => const NavigationMenu());
        } else {
          Get.offAll(() => const OnboardingScreen());
        }
      } else {
        setState(() {
          _showLoginError = true;
          _formKey.currentState!.validate();
        });
      }
    } catch (e) {
      setState(() {
        _showLoginError = true;
        _formKey.currentState!.validate();
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Giữ nguyên phần build như code cũ của bạn
    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: TSizes.spaceBtwSections),
        child: Column(
          children: [
            TextFormField(
              controller: _emailController,
              decoration: InputDecoration(
                prefixIcon: const Icon(Iconsax.direct_right),
                labelText: TTexts.email,
                hintText: TTexts.hintEmail,
                errorStyle: const TextStyle(color: Colors.red),
                labelStyle: TextStyle(
                  color: _showLoginError ? Colors.red : Colors.grey[600],
                ),
                errorBorder: _showLoginError
                    ? OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.red),
                        borderRadius: BorderRadius.circular(8),
                      )
                    : null,
                focusedErrorBorder: _showLoginError
                    ? OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.red),
                        borderRadius: BorderRadius.circular(8),
                      )
                    : null,
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: _showLoginError ? Colors.red : Colors.grey[300]!,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: _showLoginError ? Colors.red : Colors.blue,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              keyboardType: TextInputType.emailAddress,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Vui lòng nhập email';
                }
                if (!_emailPattern.hasMatch(value)) {
                  return 'Email không hợp lệ';
                }
                if (_showLoginError) {
                  return 'Email hoặc mật khẩu không đúng';
                }
                return null;
              },
            ),
            const SizedBox(height: TSizes.spaceBtwInputfields),
            TextFormField(
              controller: _passwordController,
              decoration: InputDecoration(
                prefixIcon: const Icon(Iconsax.password_check),
                labelText: TTexts.password,
                hintText: TTexts.hintPassword,
                errorStyle: const TextStyle(color: Colors.red),
                labelStyle: TextStyle(
                  color: _showLoginError ? Colors.red : Colors.grey[600],
                ),
                errorBorder: _showLoginError
                    ? OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.red),
                        borderRadius: BorderRadius.circular(8),
                      )
                    : null,
                focusedErrorBorder: _showLoginError
                    ? OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.red),
                        borderRadius: BorderRadius.circular(8),
                      )
                    : null,
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: _showLoginError ? Colors.red : Colors.grey[300]!,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: _showLoginError ? Colors.red : Colors.blue,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                suffixIcon: IconButton(
                  icon: Icon(
                    _isPasswordVisible ? Iconsax.eye : Iconsax.eye_slash,
                  ),
                  onPressed: () {
                    setState(() {
                      _isPasswordVisible = !_isPasswordVisible;
                    });
                  },
                ),
              ),
              obscureText: !_isPasswordVisible,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Vui lòng nhập mật khẩu';
                }
                if (value.length < 6) {
                  return 'Mật khẩu phải có ít nhất 6 ký tự';
                }
                if (_showLoginError) {
                  return 'Email hoặc mật khẩu không đúng';
                }
                return null;
              },
            ),
            const SizedBox(height: TSizes.spaceBtwInputfields),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Checkbox(
                      value: _rememberMe,
                      onChanged: (value) {
                        setState(() {
                          _rememberMe = value ?? false;
                        });
                      },
                    ),
                    const Text(TTexts.rememberMe),
                  ],
                ),
                TextButton(
                  onPressed: () => Get.to(() => const ForgetPassword()),
                  child: const Text(TTexts.forgetPasswordTitle),
                ),
              ],
            ),
            const SizedBox(height: TSizes.spaceBtwSections),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _login,
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text(TTexts.signIn),
              ),
            ),
            const SizedBox(height: TSizes.spaceBtwItems),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () => Get.to(() => const Signup()),
                child: const Text(TTexts.createAccount),
              ),
            ),
          ],
        ),
      ),
    );
  }
}