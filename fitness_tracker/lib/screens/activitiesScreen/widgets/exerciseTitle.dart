import 'package:flutter/material.dart';

class ExerciseTitle extends StatelessWidget {
  const ExerciseTitle({
    Key? key,
    required this.imagePath,
    required this.title,
    required this.subTitle,
    required this.onTap,
    required this.color,
  }) : super(key: key);

  final String imagePath;
  final String title, subTitle;
  final Color? color;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Image.asset(
        imagePath,
        width: 28,
        height: 28,
        color: color,
      ),
      title: Text(title, style: Theme.of(context).textTheme.titleMedium),
      subtitle: Text(subTitle, style: Theme.of(context).textTheme.labelMedium),
      onTap: onTap,
    );
  }
}