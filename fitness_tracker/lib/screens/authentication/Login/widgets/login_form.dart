import 'package:fitness_tracker/navigation_menu.dart';
import 'package:fitness_tracker/screens/onboardingFeature/OnBoardingScreen/onboardingScreen.dart';
import 'package:fitness_tracker/api/apiUrl.dart';
import 'package:fitness_tracker/utils/constants/colors.dart';
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

  @override
  void initState() {
    super.initState();
    _loadRememberMe();
  }

  Future<void> _loadRememberMe() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _rememberMe = prefs.getBool('remember_me') ?? false;
      if (_rememberMe) {
        _emailController.text = prefs.getString('user_email') ?? '';
        _passwordController.text = prefs.getString('user_password') ?? '';
      }
    });
  }

  Future<void> _saveRememberMe() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('remember_me', _rememberMe);
    if (_rememberMe) {
      await prefs.setString('user_email', _emailController.text.trim());
      await prefs.setString('user_password', _passwordController.text.trim());
    } else {
      await prefs.remove('user_email');
      await prefs.remove('user_password');
    }
  }

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

    const String apiUrl = '${ApiConfig.baseUrl}/login';

    try {
      final response = await http
          .post(
            Uri.parse(apiUrl),
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
            body: jsonEncode({'email': email, 'password': password}),
          )
          .timeout(
            const Duration(seconds: 10),
            onTimeout: () {
              throw Exception('Request timed out');
            },
          );

      final responseData = jsonDecode(response.body);

      // Kiểm tra điều kiện đăng nhập thành công
      if (response.statusCode == 200 && responseData['success'] == true) {
        final token = responseData['data']['token'];
        final firstName = responseData['data']['firstName'];
        final lastName = responseData['data']['lastName'];
        final userName = responseData['data']['userName'];
        final hasCompletedOnboarding =
            responseData['data']['hasCompletedOnboarding'] ?? false;

        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('jwt_token', token);
        await prefs.setString('user_email', email);
        await prefs.setString('first_name', firstName);
        await prefs.setString('last_name', lastName);
        await prefs.setString('user_name', userName);

        await _saveRememberMe();

        // Điều hướng dựa trên hasCompletedOnboarding
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
      print('Error occurred: $e');
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
                hintStyle: Theme.of(
                  context,
                ).textTheme.bodyMedium!.copyWith(color: TColors.grey),
                errorStyle: const TextStyle(color: Colors.red),
                labelStyle: TextStyle(
                  color: _showLoginError ? Colors.red : Colors.grey[600],
                ),
                errorBorder:
                    _showLoginError
                        ? OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.red),
                          borderRadius: BorderRadius.circular(8),
                        )
                        : null,
                focusedErrorBorder:
                    _showLoginError
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
                  return 'Please enter your email';
                }
                if (!_emailPattern.hasMatch(value)) {
                  return 'Invalid email';
                }
                if (_showLoginError) {
                  return 'Incorrect email or password!';
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
                errorBorder:
                    _showLoginError
                        ? OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.red),
                          borderRadius: BorderRadius.circular(8),
                        )
                        : null,
                focusedErrorBorder:
                    _showLoginError
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
                  return 'Please enter your password';
                }
                if (value.length < 6) {
                  return 'Password must have at least 6 characters';
                }
                if (_showLoginError) {
                  return 'Incorrect email or password!';
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
                  onPressed: () {
                    Navigator.pushNamed(context, '/forget-password');
                  },
                  child: Text(
                    TTexts.forgetPasswordTitle,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: TColors.primary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: TSizes.spaceBtwSections),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  backgroundColor:
                      _isLoading ? Colors.transparent : TColors.primary,
                  foregroundColor: _isLoading ? TColors.primary : Colors.white,
                  side: const BorderSide(color: TColors.primary),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(TSizes.borderRadiusLg),
                  ),
                ),
                onPressed: _isLoading ? null : _login,
                child:
                    _isLoading
                        ? const SizedBox(
                          width: TSizes.lg,
                          height: TSizes.lg,
                          child: CircularProgressIndicator(
                            color: TColors.primary,
                            strokeWidth: 2,
                          ),
                        )
                        : const Text(TTexts.signIn),
              ),
            ),
            const SizedBox(height: TSizes.spaceBtwItems),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/signup');
                },
                child: const Text(TTexts.createAccount),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
