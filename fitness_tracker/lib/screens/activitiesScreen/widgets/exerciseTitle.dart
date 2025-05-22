import 'package:flutter/material.dart';

class ExerciseTitle extends StatelessWidget {
  const ExerciseTitle({
    Key? key,
    required this.imagePath,
    required this.title,
    required this.subTitle,
    required this.onTap,
    this.color,
  }) : super(key: key);

  final String imagePath;
  final String title, subTitle;
  final Color? color;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Container(
        width: 56,
        height: 56,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
            colors: [
              Color(0xFF9AC1FF), // Màu bắt đầu (có thể thay đổi theo Figma)
              Color(0xFF93A7FD), // Màu kết thúc (có thể thay đổi theo Figma)
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Image.asset(imagePath, width: 28, height: 28, color: color),
        ),
      ),
      title: Text(title, style: Theme.of(context).textTheme.titleMedium),
      subtitle: Text(subTitle, style: Theme.of(context).textTheme.labelMedium),
      onTap: onTap,
    );
  }
}
