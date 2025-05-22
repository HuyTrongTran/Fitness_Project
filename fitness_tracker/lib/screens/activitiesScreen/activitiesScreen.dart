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
  List activities = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadActivities();
  }

  Future<void> _loadActivities() async {
    setState(() {
      isLoading = true;
    });
    final newData = await fetchDataFromApi();
    setState(() {
      activities = newData;
      isLoading = false;
    });
  }

  Future<List> fetchDataFromApi() async {
    // TODO: Thay bằng API thực tế
    await Future.delayed(const Duration(seconds: 1));
    return [
      {"title": "Bicep", "desc": "Improve your Bicep"},
      // ... dữ liệu khác ...
    ];
  }

  Future<void> _refreshData() async {
    await _loadActivities();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          RefreshIndicator(
            onRefresh: _refreshData,
            color: TColors.primary,
            child: CustomScrollView(
              physics: const BouncingScrollPhysics(),
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
                            style: Theme.of(context).textTheme.headlineMedium!
                                .apply(color: TColors.white),
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
                        onTap: () async {
                          final result = await Navigator.push(
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
                          if (result == true) {
                            await _loadActivities();
                          }
                        },
                      ),
                      ExerciseTitle(
                        imagePath: Images.body_back,
                        title: "Body-Back",
                        subTitle: "Improve your Body Back",
                        onTap: () async {
                          final result = await Navigator.push(
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
                          if (result == true) {
                            await _loadActivities();
                          }
                        },
                      ),
                      ExerciseTitle(
                        imagePath: Images.body_butt,
                        title: "Body Butt",
                        subTitle: "Improve your Body Butt",
                        onTap: () async {
                          final result = await Navigator.push(
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
                          if (result == true) {
                            await _loadActivities();
                          }
                        },
                      ),
                      ExerciseTitle(
                        imagePath: Images.sit_leg_core,
                        title: "Legs and core",
                        subTitle: "Improve legs and core",
                        onTap: () async {
                          final result = await Navigator.push(
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
                          if (result == true) {
                            await _loadActivities();
                          }
                        },
                      ),
                      ExerciseTitle(
                        imagePath: Images.pectoral_machine,
                        title: "Pectoral Machine",
                        subTitle:
                            "Improve your pectoral machine skills and attributes",
                        onTap: () async {
                          final result = await Navigator.push(
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
                          if (result == true) {
                            await _loadActivities();
                          }
                        },
                      ),
                      ExerciseTitle(
                        imagePath: Images.weight_loss,
                        title: "Weight Loss",
                        subTitle:
                            "This will helpful for your loss weight journey",
                        onTap: () async {
                          final result = await Navigator.push(
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
                          if (result == true) {
                            await _loadActivities();
                          }
                        },
                      ),
                      ExerciseTitle(
                        imagePath: Images.woman_up_front,
                        title: "Woman up front",
                        subTitle: "This will helpful for your up front journey",
                        onTap: () async {
                          final result = await Navigator.push(
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
                          if (result == true) {
                            await _loadActivities();
                          }
                        },
                      ),
                    ]),
                  ),
                ),
              ],
            ),
          ),
          if (isLoading)
            Container(
              color: Colors.black.withOpacity(0.5), // Nền đen mờ
              child: const Center(
                child: CircularProgressIndicator(color: TColors.primary),
              ),
            ),
        ],
      ),
    );
  }
}
