import 'package:fitness_tracker/common/widgets/appbar/appbar.dart';
import 'package:fitness_tracker/common/widgets/calendar/calendar_widget.dart';
import 'package:fitness_tracker/features/services/user_profile_services/getProfile.dart';
import 'package:fitness_tracker/screens/userProfile/profile_data.dart';
import 'package:fitness_tracker/utils/constants/colors.dart';
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
                  child: const ClipOval(
                    child: Icon(Icons.person, color: TColors.primary, size: 24),
                  ),
                );
              }
              return Container(
                width: 40,
                height: 40,
                margin: const EdgeInsets.only(right: 8),
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
                            errorBuilder: (context, error, stackTrace) {
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
                      style: Theme.of(context).textTheme.labelLarge!.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    );
                  }
                  return Text(
                    snapshot.data?.email ?? TTexts.homeAppbarTitle,
                    style: Theme.of(context).textTheme.labelLarge!.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
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
