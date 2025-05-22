import 'dart:io';

import 'package:fitness_tracker/common/widgets/appbar/appbar.dart';
import 'package:fitness_tracker/features/services/user_profile_services/getProfile.dart';
import 'package:fitness_tracker/features/services/user_profile_services/update_profile.dart';
import 'package:fitness_tracker/screens/userProfile/profile_data.dart';
import 'package:fitness_tracker/utils/constants/colors.dart';
import 'package:fitness_tracker/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:fitness_tracker/common/widgets/custome_shape/custome_snackbar/customSnackbar.dart';

class ChangeProfileScreen extends StatefulWidget {
  const ChangeProfileScreen({super.key});

  @override
  State<ChangeProfileScreen> createState() => _ChangeProfileScreenState();
}

class _ChangeProfileScreenState extends State<ChangeProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  String? _userEmail;

  File? _image;
  final ImagePicker _picker = ImagePicker();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  Future<void> _loadUserProfile() async {
    try {
      final profile = await GetProfileService.fetchProfileData();
      if (profile != null && mounted) {
        setState(() {
          _nameController.text = profile.username ?? '';
          _emailController.text = profile.email ?? '';
          _userEmail = profile.email;
        });
      }
    } catch (e) {
      print('Error loading profile: $e');
    }
  }

  Future<void> _pickImage() async {
    try {
      // Kiểm tra phiên bản Android
      if (await Permission.photos.request().isGranted ||
          await Permission.storage.request().isGranted) {
        final XFile? pickedFile = await _picker.pickImage(
          source: ImageSource.gallery,
          maxWidth: 1920,
          maxHeight: 1920,
          imageQuality: 85,
        );

        if (pickedFile != null) {
          final file = File(pickedFile.path);
          final sizeInBytes = await file.length();
          final sizeInMB = sizeInBytes / (1024 * 1024);

          if (sizeInMB > 5) {
            if (mounted) {
              showCustomSnackbar(
                'Error',
                'Image too large. Please choose an image smaller than 5MB',
                type: SnackbarType.error,
              );
            }
            return;
          }

          setState(() {
            _image = file;
          });

          if (mounted) {
            showCustomSnackbar(
              'Success',
              'Pick image successfully',
              type: SnackbarType.success,
            );
          }
        }
      } else {
        // Nếu bị từ chối, hiển thị thông báo
        if (mounted) {
          showDialog(
            context: context,
            builder:
                (BuildContext context) => AlertDialog(
                  title: const Text('Access denied'),
                  content: const Text(
                    'Please grant access to the gallery in the settings to continue.',
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () async {
                        Navigator.of(context).pop();
                        await openAppSettings();
                      },
                      child: const Text('Open settings'),
                    ),
                  ],
                ),
          );
        }
      }
    } on Exception catch (e) {
      if (mounted) {
        showCustomSnackbar(
          'Error',
          'Error when picking image: ${e.toString()}',
          type: SnackbarType.error,
        );
      }
    }
  }

  Future<void> _updateProfile() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      bool success = true;
      String errorMessage = '';

      // Cập nhật hình ảnh nếu có
      if (_image != null) {
        final imageSuccess = await UpdateProfileService.uploadProfileImage(
          _image!,
        );
        if (!imageSuccess) {
          success = false;
          errorMessage = 'Cannot upload profile image';
        }
      }

      // Cập nhật tên người dùng
      if (success) {
        final nameSuccess = await UpdateProfileService.updateUserInfo(
          userName: _nameController.text,
        );
        if (!nameSuccess) {
          success = false;
          errorMessage = 'Cannot update username';
        }
      }

      if (success && mounted) {
        showCustomSnackbar(
          'Success',
          'Update information successfully',
          type: SnackbarType.success,
        );
        Navigator.of(context).pop();
      } else if (mounted) {
        showCustomSnackbar(
          'Error',
          'Error: $errorMessage',
          type: SnackbarType.error,
        );
      }
    } catch (e) {
      if (mounted) {
        showCustomSnackbar(
          'Error',
          'Error: ${e.toString()}',
          type: SnackbarType.error,
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TAppBar(
        showBackButton: true,
        color: TColors.black,
        centerTitle: true,
        title: Text(
          "Change your profile",
          style: Theme.of(context).textTheme.headlineSmall,
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(TSizes.defaultSpace),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Profile Image
              Stack(
                children: [
                  FutureBuilder<ProfileData?>(
                    future: GetProfileService.fetchProfileData(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return Container(
                          width: 121,
                          height: 121,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                          ),
                          child: const ClipOval(
                            child: Icon(
                              Icons.person,
                              color: TColors.primary,
                              size: 24,
                            ),
                          ),
                        );
                      }
                      return Container(
                        width: 121,
                        height: 121,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                        ),
                        child: ClipOval(
                          child:
                              _image != null
                                  ? Image.file(
                                    _image!,
                                    width: 121,
                                    height: 121,
                                    fit: BoxFit.cover,
                                  )
                                  : snapshot.data?.profileImage != null
                                  ? Image.network(
                                    snapshot.data!.profileImage!,
                                    width: 121,
                                    height: 121,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      print('Error loading image: $error');
                                      return const Icon(
                                        Icons.person,
                                        color: TColors.primary,
                                        size: 24,
                                      );
                                    },
                                  )
                                  : const Icon(
                                    Icons.person,
                                    color: TColors.primary,
                                    size: 24,
                                  ),
                        ),
                      );
                    },
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      width: 35,
                      height: 35,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        color: TColors.primary,
                      ),
                      child: IconButton(
                        onPressed: _isLoading ? null : _pickImage,
                        icon: const Icon(
                          Iconsax.camera,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: TSizes.spaceBtwSections),

              // Form
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    // Name
                    TextFormField(
                      controller: _nameController,
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Iconsax.user, color: TColors.primary),
                        labelText: 'Enter your name',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your name';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: TSizes.spaceBtwItems),

                    // Email (read-only)
                    TextFormField(
                      controller: _emailController,
                      enabled: false,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(
                          Iconsax.direct,
                          color: TColors.primary,
                        ),

                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        filled: true,
                        fillColor: TColors.grey,
                      ),
                    ),
                    const SizedBox(height: TSizes.spaceBtwSections),

                    // Confirm Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _updateProfile,
                        child:
                            _isLoading
                                ? const CircularProgressIndicator()
                                : const Text("Confirm"),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
