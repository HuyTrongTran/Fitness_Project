import 'package:fitness_tracker/screens/activitiesScreen/activitiesScreen.dart';
import 'package:fitness_tracker/screens/home/home.dart';
import 'package:fitness_tracker/screens/runSessionFeature/run_screen.dart';
import 'package:fitness_tracker/screens/settings/settings.dart';
import 'package:fitness_tracker/utils/helpers/helpers_function.dart';
import 'package:fitness_tracker/utils/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:get/get.dart';

class NavigationMenu extends StatelessWidget {
  const NavigationMenu({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(NavigationController());
    final dark = HelpersFunction.isDarkMode(context);

    return Scaffold(
      bottomNavigationBar: SafeArea(
        child: Obx(
          () => Container(
            height: 90, // Tăng chiều cao để chứa nội dung
            decoration: BoxDecoration(
              color: dark ? Colors.white : Colors.white,
              boxShadow: [
                BoxShadow(
                  color:
                      dark
                          ? Colors.black.withOpacity(0.3)
                          : Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        child: _buildNavItem(
                          icon: Iconsax.home,
                          label: 'Home',
                          isSelected: controller.selectedIndex.value == 0,
                          onTap: () => controller.selectedIndex.value = 0,
                          isDark: dark,
                          context: context,
                        ),
                      ),
                      Expanded(
                        child: _buildNavItem(
                          icon: Iconsax.play,
                          label: 'Activity',
                          isSelected: controller.selectedIndex.value == 1,
                          onTap: () => controller.selectedIndex.value = 1,
                          isDark: dark,
                          context: context,
                        ),
                      ),
                      const SizedBox(width: 60), // Khoảng trống cho nút Run
                      Expanded(
                        child: _buildNavItem(
                          icon: Iconsax.profile_2user,
                          label: 'Social',
                          isSelected: controller.selectedIndex.value == 2,
                          onTap: () => controller.selectedIndex.value = 2,
                          isDark: dark,
                          context: context,
                        ),
                      ),
                      Expanded(
                        child: _buildNavItem(
                          icon: Iconsax.setting_2,
                          label: 'Settings',
                          isSelected: controller.selectedIndex.value == 3,
                          onTap: () => controller.selectedIndex.value = 3,
                          isDark: dark,
                          context: context,
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  top: -25,
                  child: Container(
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: dark ? TColors.dark : Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color:
                              dark
                                  ? Colors.black.withOpacity(0.3)
                                  : Colors.black.withOpacity(0.1),
                          blurRadius: 10,
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const RunPage(),
                          ),
                        );
                      },
                      child: Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          color: TColors.primary,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: TColors.primary.withOpacity(0.3),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Iconsax.map,
                          color: Colors.white,
                          size: 35,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: Obx(() => controller.screens[controller.selectedIndex.value]),
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
    required bool isDark,
    required BuildContext context,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: double.infinity,
        child: Stack(
          alignment: Alignment.center,
          children: [
            AnimatedOpacity(
              duration: const Duration(milliseconds: 200),
              opacity: isSelected ? 0.0 : 1.0,
              child: Icon(
                icon,
                color: isDark ? Colors.grey[400] : Colors.grey[600],
                size: 24,
              ),
            ),
            if (isSelected)
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    label,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color:
                          isDark
                              ? Colors.black
                              : Colors.black, // Đổi màu chữ cho phù hợp
                      fontSize: 12, // Giảm kích thước chữ
                    ),
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis, // Tránh tràn chữ
                  ),
                  const SizedBox(height: 2), // Giảm khoảng cách
                  Container(
                    width: 4,
                    height: 4,
                    decoration: const BoxDecoration(
                      color: TColors.primary,
                      shape: BoxShape.circle,
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}

class NavigationController extends GetxController {
  final Rx<int> selectedIndex = 0.obs;
  final screens = [
    const Home(),
    Container(color: Colors.white, child: const Center(child: Activities())),
    Container(color: Colors.white, child: const Center(child: Text('Social'))),
    Container(color: Colors.white, child: const Center(child: Settings())),
  ];
}
