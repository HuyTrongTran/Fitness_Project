import 'package:fitness_tracker/utils/constants/colors.dart';
import 'package:fitness_tracker/utils/constants/sizes.dart';
import 'package:fitness_tracker/utils/device/device_utility.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/utils.dart';
import 'package:iconsax/iconsax.dart';

class TAppBar extends StatelessWidget implements PreferredSizeWidget {
  const TAppBar({
    super.key,
    this.title,
    this.actions,
    this.leadingIcon,
    this.onLeadingPressed,
    this.showBackButton = false,
    required this.color,
    this.centerTitle = false,
  });
  final Widget? title;
  final bool showBackButton;
  final IconData? leadingIcon;
  final List<Widget>? actions;
  final VoidCallback? onLeadingPressed;
  final Color? color;
  final bool centerTitle;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: TSizes.md),
      child: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: centerTitle,
        leading:
            showBackButton
                ? IconButton(
                  onPressed: () => Get.back(),
                  icon: Icon(Iconsax.arrow_left, color: color),
                )
                : leadingIcon != null
                ? IconButton(
                  onPressed: onLeadingPressed,
                  icon: Icon(leadingIcon),
                )
                : null,
        title: title,
        actions: actions,
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(DeviceUtils.getAppBarHeight());
}
