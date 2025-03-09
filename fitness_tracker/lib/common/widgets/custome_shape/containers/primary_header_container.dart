import 'package:fitness_tracker/common/widgets/custome_shape/containers/circular_container.dart';
import 'package:fitness_tracker/common/widgets/custome_shape/curved.edges/curved_edges_widget.dart';
import 'package:fitness_tracker/utils/constants/colors.dart';
import 'package:flutter/material.dart';

class PrimaryHeaderContainer extends StatelessWidget {
  const PrimaryHeaderContainer({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return CurvedWidget(
      child: Container(
        color: TColors.primary,
        padding: const EdgeInsets.all(0),
        child: Stack(
          children: [
            // Background Custom Shapes
            Positioned(
              top: -150,
              right: -250,
              child: CircularContainer(
                backgroundColor: TColors.textWhite.withOpacity(0.1),
              ),
            ),
            Positioned(
              top: 100,
              right: -300,
              child: CircularContainer(
                backgroundColor: TColors.textWhite.withOpacity(0.1),
              ),
            ),
            child,
          ],
        ),
      ),
    );
  }
}
