import 'package:fitness_tracker/common/widgets/custome_shape/custome_snackbar/customSnackbar.dart';
import 'package:fitness_tracker/screens/authentication/Login/login.dart';
import 'package:fitness_tracker/api/apiUrl.dart';
import 'package:fitness_tracker/utils/constants/sizes.dart';
import 'package:fitness_tracker/utils/constants/text_strings.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

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

  bool _isLoading = false;
  bool _isPasswordVisible = false;
  bool _isTermsAccepted = false;

  Future<void> _signUp() async {
    if (!_formKey.currentState!.validate() || !_isTermsAccepted) {
      if (!_isTermsAccepted) {
        showCustomSnackbar('Processing', 'Request timed out', type: SnackbarType.processing);
      }
      print('Form validation failed or terms not accepted');
      return;
    }

    print('Form validation passed, calling API...');

    setState(() {
      _isLoading = true;
    });

    const String apiUrl = '${ApiConfig.baseUrl}/register';

    try {
      print('Sending request to $apiUrl');
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
              showCustomSnackbar('Error', 'Request timed out', type: SnackbarType.error);
              throw Exception('Request timed out');
            },
          );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 201 && responseData['success'] == true) {
        showCustomSnackbar(
          'Success',
          'Registration successful! Please log in.',
          type: SnackbarType.success,
        );
        Get.off(() => const Login());
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
            child: ElevatedButton(
              onPressed: _isLoading ? null : _signUp,
              child:
                  _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(TTexts.signUp),
            ),
          ),
        ],
      ),
    );
  }
}
