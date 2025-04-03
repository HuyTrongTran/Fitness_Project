import 'package:fitness_tracker/common/widgets/appbar/appbar.dart';
import 'package:fitness_tracker/common/widgets/calendar/calendar_widget.dart';
import 'package:fitness_tracker/features/services/getProfile.dart';
import 'package:fitness_tracker/userProfile/profile_data.dart';
import 'package:fitness_tracker/utils/constants/colors.dart';
import 'package:fitness_tracker/utils/constants/image_strings.dart';
import 'package:fitness_tracker/utils/constants/text_strings.dart';
import 'package:flutter/material.dart';
import 'calendar_popup.dart';

class HomeAppBar extends StatelessWidget {
  final Function(DateTime) onDaySelected;

  const HomeAppBar({super.key, required this.onDaySelected});

  @override
  Widget build(BuildContext context) {
    return TAppBar(
      color: TColors.white,
      title: Row(
        children: [
          FutureBuilder<ProfileData?>(
            future: ApiService.fetchProfileData(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Container(
                  width: 40,
                  height: 40,
                  margin: const EdgeInsets.only(right: 8),
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                  ),
                  child: const Icon(
                    Icons.person,
                    color: TColors.primary,
                    size: 24,
                  ),
                );
              }
              return Container(
                width: 40,
                height: 40,
                margin: const EdgeInsets.only(right: 8),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image:
                        snapshot.data?.profileImage != null
                            ? NetworkImage(snapshot.data!.profileImage!)
                            : AssetImage(Images.profile) as ImageProvider,
                    fit: BoxFit.cover,
                  ),
                ),
              );
            },
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FutureBuilder<ProfileData?>(
                future: ApiService.fetchProfileData(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Text(
                      'No profile data',
                      style: Theme.of(
                        context,
                      ).textTheme.headlineSmall!.apply(color: Colors.white),
                    );
                  }
                  return Text(
                    snapshot.data?.username ?? TTexts.homeAppbarSubTitle,
                    style: Theme.of(
                      context,
                    ).textTheme.headlineSmall!.apply(color: Colors.white),
                  );
                },
              ),
              FutureBuilder<ProfileData?>(
                future: ApiService.fetchProfileData(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Text(
                      'No profile data',
                      style: Theme.of(
                        context,
                      ).textTheme.labelLarge!.apply(color: Colors.white),
                    );
                  }
                  return Text(
                    snapshot.data?.email ?? TTexts.homeAppbarTitle,
                    style: Theme.of(
                      context,
                    ).textTheme.labelLarge!.apply(color: Colors.white),
                  );
                },
              ),
            ],
          ),
        ],
      ),
      actions: [
        CalenderCountericon(
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) => CalendarPopup(onDaySelected: onDaySelected),
            );
          },
          iconColor: TColors.white,
        ),
      ],
    );
  }
}
