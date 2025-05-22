import 'package:fitness_tracker/common/widgets/appbar/appbar.dart';
import 'package:fitness_tracker/common/widgets/calendar/calendar_widget.dart';
import 'package:fitness_tracker/features/services/user_profile_services/getProfile.dart';
import 'package:fitness_tracker/screens/userProfile/profile_data.dart';
import 'package:fitness_tracker/utils/constants/colors.dart';
import 'package:fitness_tracker/utils/constants/text_strings.dart';
import 'package:flutter/material.dart';
import 'calendar_popup.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fitness_tracker/api/apiUrl.dart';

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
            future: GetProfileService.fetchProfileData(),
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
                future: GetProfileService.fetchProfileData(),
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
                future: GetProfileService.fetchProfileData(),
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
        FutureBuilder<http.Response>(
          future: _fetchWorkoutPlanForToday(),
          builder: (context, snapshot) {
            int exerciseCount = 0;
            if (snapshot.hasData && snapshot.data != null) {
              try {
                final data = snapshot.data!.body;
                final decoded = data != null ? jsonDecode(data) : null;
                if (decoded != null &&
                    decoded['success'] == true &&
                    decoded['data'] != null &&
                    decoded['data']['exercises'] != null) {
                  exerciseCount = (decoded['data']['exercises'] as List).length;
                }
              } catch (e) {
                exerciseCount = 0;
              }
            }
            return CalenderCountericon(
              exerciseCount: exerciseCount,
              onPressed: () {
                showDialog(
                  context: context,
                  builder:
                      (context) => CalendarPopup(onDaySelected: onDaySelected),
                );
              },
              iconColor: TColors.white,
            );
          },
        ),
      ],
    );
  }

  Future<http.Response> _fetchWorkoutPlanForToday() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('jwt_token');
    if (token == null) {
      throw Exception('No token found');
    }
    final today = DateTime.now().toIso8601String().split('T')[0];
    final String apiUrl = '${ApiConfig.baseUrl}/activity-data?date=$today';
    return await http.get(
      Uri.parse(apiUrl),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );
  }
}
