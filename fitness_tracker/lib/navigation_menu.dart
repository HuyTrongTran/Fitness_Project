import 'package:fitness_tracker/screens/home/home.dart';
import 'package:fitness_tracker/utils/helpers/helpers_function.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:get/get.dart';

class NavigationMenu extends StatelessWidget {
  const NavigationMenu({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(NavigationController());
    final darkMode = HelpersFunction.isDarkMode(context);

    return Scaffold(
      bottomNavigationBar: Obx(
        () => NavigationBar(
          height: 80,
          elevation: 0,
          selectedIndex: controller.selectedIndex.value,
          onDestinationSelected:
              (index) => controller.selectedIndex.value = index,
          indicatorColor:
              darkMode
                  ? Colors.white.withOpacity(0.1)
                  : Colors.black.withOpacity(0.1),
          destinations: const [
            NavigationDestination(icon: Icon(Iconsax.home), label: 'Home'),
            NavigationDestination(icon: Icon(Iconsax.chart), label: 'Progress'),
            NavigationDestination(
              icon: Icon(Iconsax.profile_2user),
              label: 'User',
            ),
            NavigationDestination(
              icon: Icon(Iconsax.setting_2),
              label: 'Settings',
            ),
          ],
        ),
      ),
      body: Obx(() => controller.screens[controller.selectedIndex.value]),
    );
  }
}

class NavigationController extends GetxController {
  final Rx<int> selectedIndex = 0.obs;
  final screens = [
    const Home(),
    Container(
      color: Colors.white,
      child: const Center(child: Text('Progress')),
    ),
    Container(
      color: Colors.white,
      child: const Center(child: Text('Community')),
    ),
    Container(
      color: Colors.white,
      child: const Center(child: Text('Settings')),
    ),
  ];
}
