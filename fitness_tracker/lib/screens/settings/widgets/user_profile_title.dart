import 'package:fitness_tracker/screens/settings/changeProfile.dart';
import 'package:fitness_tracker/utils/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/instance_manager.dart';
import 'package:iconsax/iconsax.dart';

class UserProfileTitle extends StatelessWidget {
  const UserProfileTitle({
    super.key,
    required this.name,
    required this.email,
    required this.profileImage,
  });

  final Widget name;
  final Widget email;
  final Widget profileImage;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: profileImage,
      title: name,
      subtitle: email,
      trailing: IconButton(
        onPressed: () async {
          Get.to(() => const ChangeProfileScreen());
        },
        icon: const Icon(Iconsax.edit, color: TColors.white),
      ),
    );
  }
}
