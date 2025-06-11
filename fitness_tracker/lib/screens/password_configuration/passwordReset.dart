import 'package:fitness_tracker/features/services/authentication_services/forgotPasswordService.dart';
import 'package:fitness_tracker/utils/constants/colors.dart';
import 'package:fitness_tracker/utils/constants/sizes.dart';
import 'package:fitness_tracker/utils/constants/text_strings.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class ResetPassword extends StatefulWidget {
  const ResetPassword({super.key});

  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  final _formKey = GlobalKey<FormState>();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isLoading = false;
  bool _isNewPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  @override
  void dispose() {
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _updatePassword() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      try {
        final result = await ForgotPasswordService.resetPassword(
          newPassword: _newPasswordController.text,
        );
        if (result['success']) {
          Get.snackbar(
            'Success',
            'Password changed successfully! Let\'s build your fitness journey.',
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.green,
            colorText: Colors.white,
            duration: const Duration(seconds: 3),
            margin: const EdgeInsets.all(10),
            isDismissible: true,
            forwardAnimationCurve: Curves.easeOutBack,
          );
          await Future.delayed(const Duration(seconds: 2));
          // Navigate to home instead of logging out since user just logged in
          Get.offAllNamed('/'); // or Get.offAll(() => const NavigationMenu());
        } else {
          Get.snackbar(
            'Error',
            result['message'] ?? 'Error occurs when changing the password',
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.red,
            colorText: Colors.white,
            duration: const Duration(seconds: 3),
            margin: const EdgeInsets.all(10),
            isDismissible: true,
            forwardAnimationCurve: Curves.easeOutBack,
          );
        }
      } catch (e) {
        Get.snackbar(
          'Error',
          'Please try again',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          duration: const Duration(seconds: 3),
          margin: const EdgeInsets.all(10),
          isDismissible: true,
          forwardAnimationCurve: Curves.easeOutBack,
        );
      } finally {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(TSizes.defaultSpace),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Headings
                Text(
                  'Reset Your Password',
                  style: Theme.of(context).textTheme.headlineLarge,
                ),
                const SizedBox(height: TSizes.spaceBtwItems),
                Text(
                  'You must set a new password to continue using the app. Please choose a strong password.',
                  style: Theme.of(context).textTheme.labelMedium,
                ),
                const SizedBox(height: TSizes.spaceBtwItems * 2),

                // New Password TextField
                TextFormField(
                  controller: _newPasswordController,
                  obscureText: !_isNewPasswordVisible,
                  decoration: InputDecoration(
                    labelText: TTexts.newPassword,
                    labelStyle: Theme.of(context).textTheme.labelMedium,
                    prefixIcon: const Icon(Iconsax.key_square),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isNewPasswordVisible ? Iconsax.eye : Iconsax.eye_slash,
                      ),
                      onPressed: () {
                        setState(() {
                          _isNewPasswordVisible = !_isNewPasswordVisible;
                        });
                      },
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your new password';
                    }
                    if (value.length < 6) {
                      return 'Password must be at least 6 characters';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: TSizes.spaceBtwItems),
                TextFormField(
                  controller: _confirmPasswordController,
                  obscureText: !_isConfirmPasswordVisible,
                  decoration: InputDecoration(
                    labelText: TTexts.confirmNewPassword,
                    labelStyle: Theme.of(context).textTheme.labelMedium,
                    prefixIcon: const Icon(Iconsax.keyboard),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isConfirmPasswordVisible
                            ? Iconsax.eye
                            : Iconsax.eye_slash,
                      ),
                      onPressed: () {
                        setState(() {
                          _isConfirmPasswordVisible =
                              !_isConfirmPasswordVisible;
                        });
                      },
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please confirm your new password';
                    }
                    if (value != _newPasswordController.text) {
                      return 'Passwords do not match';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: TSizes.spaceBtwItems),

                // Button submit
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _updatePassword,
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
                            : const Text(TTexts.submit),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
