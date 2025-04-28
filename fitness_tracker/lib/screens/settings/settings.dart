import 'package:fitness_tracker/common/widgets/appbar/appbar.dart';
import 'package:fitness_tracker/common/widgets/custome_shape/containers/primary_header_container.dart';
import 'package:fitness_tracker/common/widgets/texts/section_heading.dart';
import 'package:fitness_tracker/screens/authentication/changePassword/change_password.dart';
import 'package:fitness_tracker/screens/settings/bodyIndex.dart';
import 'package:fitness_tracker/screens/settings/widgets/setting_menu_title.dart';
import 'package:fitness_tracker/screens/settings/widgets/user_profile_title.dart';
import 'package:fitness_tracker/utils/constants/colors.dart';
import 'package:fitness_tracker/utils/constants/sizes.dart';
import 'package:fitness_tracker/utils/constants/text_strings.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:fitness_tracker/features/services/user_profile_services/getProfile.dart';
import 'package:fitness_tracker/screens/userProfile/profile_data.dart';
import 'package:fitness_tracker/features/services/authentication_services/logout.dart';

class Settings extends StatelessWidget {
  const Settings({super.key});

  Future<ProfileData?> fetchProfileData() async {
    final response = await ApiService.fetchProfileData();
    return response;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            PrimaryHeaderContainer(
              child: Column(
                children: [
                  TAppBar(
                    color: TColors.white,
                    title: Text(
                      "Settings",
                      style: Theme.of(
                        context,
                      ).textTheme.headlineMedium!.apply(color: TColors.white),
                    ),
                  ),
                  UserProfileTitle(
                    profileImage: FutureBuilder<ProfileData?>(
                      future: ApiService.fetchProfileData(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return Container(
                            width: 40,
                            height: 40,
                            // margin: const EdgeInsets.only(right: 8),
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white,
                            ),
                            child: const ClipOval(
                              child: Icon(
                                Icons.person,
                                color: TColors.primary,
                                size: 24,
                              ),
                            ),
                          );
                        }
                        return Container(
                          width: 50,
                          height: 50,
                          // margin: const EdgeInsets.only(right: 8),
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                          ),
                          child: ClipOval(
                            child:
                                snapshot.data?.profileImage != null
                                    ? Image.network(
                                      snapshot.data!.profileImage!,
                                      width: 40,
                                      height: 40,
                                      fit: BoxFit.cover,
                                      errorBuilder: (
                                        context,
                                        error,
                                        stackTrace,
                                      ) {
                                        print('Error loading image: $error');
                                        return const Icon(
                                          Icons.person,
                                          color: TColors.primary,
                                          size: 24,
                                        );
                                      },
                                    )
                                    : const Icon(
                                      Icons.person,
                                      color: TColors.primary,
                                      size: 24,
                                    ),
                          ),
                        );
                      },
                    ),
                    name: FutureBuilder<ProfileData?>(
                      future: ApiService.fetchProfileData(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return Text(
                            'No profile data',
                            style: Theme.of(context).textTheme.titleMedium!
                                .apply(color: TColors.white),
                          );
                        }
                        return Text(
                          snapshot.data?.username ?? TTexts.homeAppbarTitle,
                          style: Theme.of(
                            context,
                          ).textTheme.titleMedium!.apply(color: TColors.white),
                        );
                      },
                    ),
                    email: FutureBuilder<ProfileData?>(
                      future: ApiService.fetchProfileData(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return Text(
                            'No profile data',
                            style: Theme.of(
                              context,
                            ).textTheme.bodyMedium!.apply(color: TColors.white),
                          );
                        }
                        return Text(
                          snapshot.data?.email ?? TTexts.homeAppbarSubTitle,
                          style: Theme.of(
                            context,
                          ).textTheme.bodyMedium!.apply(color: TColors.white),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: TSizes.spaceBtwSections),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(TSizes.defaultSpace),
              child: Column(
                children: [
                  SectionHeading(title: 'Account Settings', onPressed: () {}),
                  const SizedBox(height: TSizes.spaceBtwItems),
                  SettingMenuTitle(
                    icon: Iconsax.user,
                    title: "Body Index",
                    subTitle: "Set your profile details",
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ProfileScreen(),
                        ),
                      );
                    },
                  ),
                  SettingMenuTitle(
                    icon: Iconsax.notification,
                    title: "Notifications",
                    subTitle: "Set notifications preferences",
                    onTap: () {},
                  ),
                  SettingMenuTitle(
                    icon: Iconsax.key,
                    title: "Change Password",
                    subTitle: "Change your password",
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ChangePassword(),
                        ),
                      );
                    },
                  ),
                  SettingMenuTitle(
                    icon: Iconsax.logout,
                    title: "Logout",
                    subTitle: "Logout from your account",
                    onTap: () async {
                      await LogoutService.logout();
                    },
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
