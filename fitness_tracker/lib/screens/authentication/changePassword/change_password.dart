import 'package:fitness_tracker/features/services/authentication_services/change_password_services.dart';
import 'package:fitness_tracker/features/services/authentication_services/logout.dart';
import 'package:fitness_tracker/utils/constants/colors.dart';
import 'package:fitness_tracker/utils/constants/sizes.dart';
import 'package:fitness_tracker/utils/constants/text_strings.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({super.key});

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  final _formKey = GlobalKey<FormState>();
  final _oldPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isLoading = false;
  bool _isOldPasswordVisible = false;
  bool _isNewPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  @override
  void dispose() {
    _oldPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _updatePassword() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      try {
        final result = await ChangePasswordService.updatePassword(
          oldPassword: _oldPasswordController.text,
          newPassword: _newPasswordController.text,
        );

        if (result['success']) {
          Get.snackbar(
            'Success',
            'Password changed successfully',
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.green,
            colorText: Colors.white,
            duration: const Duration(seconds: 3),
            margin: const EdgeInsets.all(10),
            isDismissible: true,
            forwardAnimationCurve: Curves.easeOutBack,
          );
          await Future.delayed(const Duration(seconds: 2));
          await LogoutService.logout();
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
                  TTexts.changePassword,
                  style: Theme.of(context).textTheme.headlineLarge,
                ),
                const SizedBox(height: TSizes.spaceBtwItems),
                Text(
                  TTexts.changePasswordSubtitle,
                  style: Theme.of(context).textTheme.labelMedium,
                ),
                const SizedBox(height: TSizes.spaceBtwItems * 2),

                // TextField
                TextFormField(
                  controller: _oldPasswordController,
                  obscureText: !_isOldPasswordVisible,
                  decoration: InputDecoration(
                    labelText: TTexts.oldPassword,
                    labelStyle: Theme.of(context).textTheme.labelMedium,
                    prefixIcon: const Icon(Iconsax.key),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isOldPasswordVisible ? Iconsax.eye : Iconsax.eye_slash,
                      ),
                      onPressed: () {
                        setState(() {
                          _isOldPasswordVisible = !_isOldPasswordVisible;
                        });
                      },
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your old password';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: TSizes.spaceBtwItems),
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
