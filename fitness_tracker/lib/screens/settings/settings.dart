import 'package:fitness_tracker/common/widgets/appbar/appbar.dart';
import 'package:fitness_tracker/common/widgets/custome_shape/containers/circular_image.dart';
import 'package:fitness_tracker/common/widgets/custome_shape/containers/primary_header_container.dart';
import 'package:fitness_tracker/common/widgets/texts/section_heading.dart';
import 'package:fitness_tracker/screens/settings/widgets/setting_menu_title.dart';
import 'package:fitness_tracker/screens/settings/widgets/user_profile_title.dart';
import 'package:fitness_tracker/utils/constants/colors.dart';
import 'package:fitness_tracker/utils/constants/image_strings.dart';
import 'package:fitness_tracker/utils/constants/sizes.dart';
import 'package:fitness_tracker/utils/constants/text_strings.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:fitness_tracker/features/services/getProfile.dart';
import 'package:fitness_tracker/userProfile/profile_data.dart';
import 'package:fitness_tracker/features/services/logout/logout.dart';

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
                      "Account",
                      style: Theme.of(
                        context,
                      ).textTheme.headlineMedium!.apply(color: TColors.white),
                    ),
                  ),
                  UserProfileTitle(
                    profileImage: FutureBuilder<ProfileData?>(
                      future: fetchProfileData(),
                      builder: (context, snapshot) {
                        return CircularImage(
                          image: snapshot.data?.profileImage ?? Images.profile,
                          width: 50,
                          height: 50,
                          padding: 0,
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
                    icon: Iconsax.notification,
                    title: "Notifications",
                    subTitle: "Set notifications preferences",
                    onTap: () {},
                  ),
                  SettingMenuTitle(
                    icon: Iconsax.key,
                    title: "Change Password",
                    subTitle: "Change your password",
                    onTap: () {},
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
