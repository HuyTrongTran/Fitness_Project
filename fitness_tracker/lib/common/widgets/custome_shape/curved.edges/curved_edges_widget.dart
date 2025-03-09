import 'package:fitness_tracker/common/widgets/custome_shape/curved.edges/curved_edges.dart';
import 'package:fitness_tracker/utils/constants/colors.dart';
import 'package:flutter/material.dart';

class CurvedWidget extends StatelessWidget {
  const CurvedWidget({super.key, required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: CustomCurvedEdges(),
      child: Container(
        color: TColors.primary,
        padding: const EdgeInsets.all(0),
        child: SizedBox(height: 400, child: child),
      ),
    );
  }
}
