import 'package:fitness_tracker/utils/constants/colors.dart';
import 'package:flutter/material.dart';

class SettingMenuTitle extends StatelessWidget {
  const SettingMenuTitle({super.key, required this.icon, required this.title, required this.subTitle, this.trailing, required this.onTap});

  final IconData icon;
  final String title, subTitle;
  final Widget? trailing;
  final VoidCallback? onTap;
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, size: 28, color: TColors.primary),
      title: Text(title, style: Theme.of(context).textTheme.titleMedium!.copyWith(fontWeight: FontWeight.bold)),
      subtitle: Text(subTitle, style: Theme.of(context).textTheme.labelMedium),
      trailing: trailing,
      onTap: onTap,
    );
  }
}  