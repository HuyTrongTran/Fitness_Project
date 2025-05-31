import 'package:fitness_tracker/common/widgets/custome_shape/custome_snackbar/customSnackbar.dart';
import 'package:fitness_tracker/screens/authentication/signup/widgets/verify_email.dart';
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
class SignUpForm extends StatefulWidget {
  const SignUpForm({super.key});

  @override
  _SignUpFormState createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _userNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _isLoading = false;
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  bool _isTermsAccepted = false;

  Future<void> _signUp() async {
    if (!_formKey.currentState!.validate() || !_isTermsAccepted) {
      if (!_isTermsAccepted) {
        showCustomSnackbar(
          'Processing',
          'Please accept the terms and conditions',
          type: SnackbarType.processing,
        );
      }

      return;
    }

    setState(() {
      _isLoading = true;
    });

    const String apiUrl = '${ApiConfig.baseUrl}/register';

    try {
      final response = await http
          .post(
            Uri.parse(apiUrl),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({
              'firstName': _firstNameController.text.trim(),
              'lastName': _lastNameController.text.trim(),
              'userName': _userNameController.text.trim(),
              'email': _emailController.text.trim(),
              'password': _passwordController.text.trim(),
            }),
          )
          .timeout(
            const Duration(seconds: 10),
            onTimeout: () {
              showCustomSnackbar(
                'Error',
                'Please enter all fields',
                type: SnackbarType.error,
              );
              throw Exception('Please enter all fields');
            },
          );
      final responseData = jsonDecode(response.body);
      // Save information in shared preferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('firstName', _firstNameController.text.trim());
      prefs.setString('lastName', _lastNameController.text.trim());
      prefs.setString('userName', _userNameController.text.trim());
      prefs.setString('email', _emailController.text.trim());

      if (response.statusCode == 201 && responseData['success'] == true) {
        showCustomSnackbar(
          'Success',
          'Registration successful! Please verify your email.',
          type: SnackbarType.success,
        );
        Get.to(() => const VerifyEmail());
      } else {
        Get.snackbar('Error', responseData['message'] ?? 'Registration failed');
      }
    } catch (e) {
      print('Error occurred: $e');
      Get.snackbar('Error', 'An error occurred: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _userNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: _firstNameController,
                  decoration: const InputDecoration(
                    labelText: TTexts.firstName,
                    prefixIcon: Icon(Iconsax.user),
                    contentPadding: EdgeInsets.all(TSizes.md),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter your first name';
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(width: TSizes.spaceBtwInputfields),
              Expanded(
                child: TextFormField(
                  controller: _lastNameController,
                  decoration: const InputDecoration(
                    labelText: TTexts.lastName,
                    prefixIcon: Icon(Iconsax.user),
                    contentPadding: EdgeInsets.all(TSizes.md),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter your last name';
                    }
                    return null;
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: TSizes.spaceBtwInputfields),
          TextFormField(
            controller: _userNameController,
            decoration: const InputDecoration(
              labelText: TTexts.username,
              prefixIcon: Icon(Iconsax.user_edit),
              contentPadding: EdgeInsets.all(TSizes.md),
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Please enter your username';
              }
              if (value.trim().length < 3) {
                return 'Username must be at least 3 characters';
              }
              return null;
            },
          ),
          const SizedBox(height: TSizes.spaceBtwInputfields),
          TextFormField(
            controller: _emailController,
            decoration: const InputDecoration(
              labelText: TTexts.email,
              prefixIcon: Icon(Iconsax.message_text),
              contentPadding: EdgeInsets.all(TSizes.md),
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Please enter your email';
              }
              if (!RegExp(
                r'^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+',
              ).hasMatch(value)) {
                return 'Please enter a valid email';
              }
              return null;
            },
          ),
          const SizedBox(height: TSizes.spaceBtwInputfields),
          TextFormField(
            controller: _passwordController,
            obscureText: !_isPasswordVisible,
            decoration: InputDecoration(
              labelText: TTexts.password,
              prefixIcon: const Icon(Iconsax.password_check),
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
              contentPadding: const EdgeInsets.all(TSizes.md),
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Please enter your password';
              }
              if (value.trim().length < 6) {
                return 'Password must be at least 6 characters';
              }
              return null;
            },
          ),
          const SizedBox(height: TSizes.spaceBtwInputfields),
          TextFormField(
            controller: _confirmPasswordController,
            obscureText: !_isConfirmPasswordVisible,
            decoration: InputDecoration(
              labelText: TTexts.confirmPassword,
              prefixIcon: const Icon(Iconsax.password_check),
              suffixIcon: IconButton(
                icon: Icon(
                  _isConfirmPasswordVisible ? Iconsax.eye : Iconsax.eye_slash,
                ),
                onPressed: () {
                  setState(() {
                    _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
                  });
                },
              ),
              contentPadding: const EdgeInsets.all(TSizes.md),
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Please enter your confirm password';
              }
              if (value != _passwordController.text) {
                return 'Passwords do not match';
              }
              return null;
            },
          ),
          const SizedBox(height: TSizes.spaceBtwSections),
          Row(
            children: [
              Checkbox(
                value: _isTermsAccepted,
                onChanged: (value) {
                  setState(() {
                    _isTermsAccepted = value ?? false;
                  });
                },
              ),
              const Text('I agree to the Terms & Conditions'),
            ],
          ),
          const SizedBox(height: TSizes.spaceBtwItems),
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
              onPressed:() {
                if (_isLoading) {
                  return;
                }
                _signUp();              
              },
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
                      : const Text(TTexts.signUp),
            ),
          ),
        ],
      ),
    );
  }
}
