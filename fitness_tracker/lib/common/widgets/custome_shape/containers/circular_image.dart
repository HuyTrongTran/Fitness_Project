import 'package:flutter/material.dart';

class CircularImage extends StatelessWidget {
  const CircularImage({
    super.key,
    this.width = 56,
    this.height = 56,
    this.overlayColor,
    this.backgroundColor,
    this.padding = 0,
    this.isNetworkImage = false,
    this.image,
    this.fit = BoxFit.cover,
  });

  final double width;
  final double height;
  final Color? overlayColor;
  final Color? backgroundColor;
  final double padding;
  final bool isNetworkImage;
  final String? image;
  final BoxFit? fit;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      padding: EdgeInsets.all(padding),
      decoration: BoxDecoration(
        color: backgroundColor ?? Colors.white,
        borderRadius: BorderRadius.circular(100),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(100),
        child:
            image != null
                ? isNetworkImage
                    ? Image.network(
                      image!,
                      fit: fit,
                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(Icons.person_outline);
                      },
                    )
                    : Image.asset(image!, fit: fit)
                : const Icon(Icons.person_outline),
      ),
    );
  }
}
