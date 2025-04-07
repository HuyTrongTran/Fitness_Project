import 'package:fitness_tracker/common/widgets/appbar/appbar.dart';
import 'package:fitness_tracker/common/widgets/custome_shape/containers/primary_header_container.dart';
import 'package:fitness_tracker/common/widgets/texts/section_heading.dart';
import 'package:fitness_tracker/screens/activitiesScreen/setCalendars.dart';
import 'package:fitness_tracker/screens/activitiesScreen/widgets/exerciseTitle.dart';
import 'package:fitness_tracker/screens/home/widgets/workout_plan.dart';
import 'package:fitness_tracker/utils/constants/colors.dart';
import 'package:fitness_tracker/utils/constants/image_strings.dart';
import 'package:fitness_tracker/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Activities extends StatefulWidget {
  const Activities({super.key});

  @override
  _ActivitiesState createState() => _ActivitiesState();
}

class _ActivitiesState extends State<Activities> {
  // Hàm reload dữ liệu (giả lập)
  Future<void> _refreshData() async {
    // Thêm logic tải lại dữ liệu ở đây, ví dụ gọi API
    await Future.delayed(const Duration(seconds: 1)); // Giả lập thời gian chờ
    setState(() {
      // Cập nhật lại giao diện nếu cần
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: _refreshData, // Hàm được gọi khi kéo xuống để reload
        color: TColors.primary, // Màu của vòng tròn loading
        child: CustomScrollView(
          physics:
              const BouncingScrollPhysics(), // Cuộn mượt mà với hiệu ứng bật lại
          slivers: [
            // Fixed Header
            SliverToBoxAdapter(
              child: PrimaryHeaderContainer(
                child: Column(
                  children: [
                    TAppBar(
                      color: TColors.white,
                      title: Text(
                        "Start Workout",
                        style: Theme.of(
                          context,
                        ).textTheme.headlineMedium!.apply(color: TColors.white),
                      ),
                    ),
                    WorkoutPlan(
                      selectedDate:
                          DateTime.now(), // Luôn hiển thị ngày hiện tại
                      isInPopup: false,
                    ),
                    const SizedBox(height: TSizes.spaceBtwSections),
                  ],
                ),
              ),
            ),
            // Scrollable Content
            SliverPadding(
              padding: const EdgeInsets.all(TSizes.defaultSpace),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  SectionHeading(title: 'Body workout', onPressed: () {}),
                  const SizedBox(height: TSizes.spaceBtwItems),
                  ExerciseTitle(
                    imagePath: Images.bicep,
                    title: "Bicep",
                    subTitle: "Improve your Bicep",
                    color: TColors.primary,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) => const SetCalendars(
                                icon: Images.bicep,
                                title: 'Bicep',
                                subTitle: 'Improve your Bicep',
                              ),
                        ),
                      );
                    },
                  ),
                  ExerciseTitle(
                    imagePath: Images.body_back,
                    title: "Body-Back",
                    subTitle: "Improve your Body Back",
                    color: TColors.primary,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) => const SetCalendars(
                                icon: Images.body_back,
                                title: 'Body-Back',
                                subTitle: 'Improve your Body Back',
                              ),
                        ),
                      );
                    },
                  ),
                  ExerciseTitle(
                    imagePath: Images.body_butt,
                    title: "Body Butt",
                    subTitle: "Improve your Body Butt",
                    color: TColors.primary,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) => const SetCalendars(
                                icon: Images.body_butt,
                                title: 'Body Butt',
                                subTitle: 'Improve your Body Butt',
                              ),
                        ),
                      );
                    },
                  ),
                  ExerciseTitle(
                    imagePath: Images.sit_leg_core,
                    title: "Legs and core",
                    subTitle: "Improve legs and core",
                    color: TColors.primary,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) => const SetCalendars(
                                icon: Images.sit_leg_core,
                                title: 'Legs and core',
                                subTitle: 'Improve legs and core',
                              ),
                        ),
                      );
                    },
                  ),
                  ExerciseTitle(
                    imagePath: Images.pectoral_machine,
                    title: "Pectoral Machine",
                    subTitle:
                        "Improve your pectoral machine skills and attributes",
                    color: TColors.primary,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) => const SetCalendars(
                                icon: Images.pectoral_machine,
                                title: 'Pectoral Machine',
                                subTitle:
                                    'Improve your pectoral machine skills and attributes',
                              ),
                        ),
                      );
                    },
                  ),
                  ExerciseTitle(
                    imagePath: Images.stand_leg_core,
                    title: "Legs and core",
                    subTitle: "Improve legs and core",
                    color: TColors.primary,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) => const SetCalendars(
                                icon: Images.stand_leg_core,
                                title: 'Legs and core',
                                subTitle: 'Improve legs and core',
                              ),
                        ),
                      );
                    },
                  ),
                  ExerciseTitle(
                    imagePath: Images.weight_loss,
                    title: "Weight Loss",
                    subTitle: "This will helpful for your loss weight journey",
                    color: TColors.primary,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) => const SetCalendars(
                                icon: Images.weight_loss,
                                title: 'Weight Loss',
                                subTitle:
                                    'This will helpful for your loss weight journey',
                              ),
                        ),
                      );
                    },
                  ),
                  ExerciseTitle(
                    imagePath: Images.woman_up_front,
                    title: "Woman up front",
                    subTitle: "This will helpful for your up front journey",
                    color: TColors.primary,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) => const SetCalendars(
                                icon: Images.woman_up_front,
                                title: 'Woman up front',
                                subTitle:
                                    'This will helpful for your up front journey',
                              ),
                        ),
                      );
                    },
                  ),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
