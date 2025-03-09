import 'package:fitness_tracker/common/widgets/appbar/appbar.dart';
import 'package:fitness_tracker/common/widgets/calendar/calendar_widget.dart';
import 'package:fitness_tracker/common/widgets/custome_shape/containers/primary_header_container.dart';
import 'package:fitness_tracker/utils/constants/colors.dart';
import 'package:fitness_tracker/utils/constants/text_strings.dart';
import 'package:flutter/material.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header -- Tutorial [Section # 3, Video # 2]
            PrimaryHeaderContainer(
              child: Column(
                children: [
                  TAppBar(
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          TTexts.homeAppbarTitle,
                          style: Theme.of(
                            context,
                          ).textTheme.labelMedium!.apply(color: Colors.grey),
                        ),
                        Text(
                          TTexts.homeAppbarSubTitle,
                          style: Theme.of(
                            context,
                          ).textTheme.headlineSmall!.apply(color: Colors.white),
                        ),
                      ],
                    ),
                    actions: [
                      CalenderCountericon(
                        onPressed: () {},
                        iconColor: TColors.white,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

