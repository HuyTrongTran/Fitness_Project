import 'package:get/get.dart';
import 'package:fitness_tracker/features/services/user_profile_services/getProfile.dart';
import 'package:fitness_tracker/screens/userProfile/profile_data.dart';

class ProfileController extends GetxController {
  static ProfileController get instance => Get.find();

  final Rx<ProfileData?> profileData = Rx<ProfileData?>(null);
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadProfileData();
  }

  Future<void> loadProfileData() async {
    try {
      isLoading.value = true;
      final data = await ApiService.fetchProfileData();
      profileData.value = data;
    } catch (e) {
      print('Error loading profile data: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateProfileData({
    String? username,
    String? email,
    String? profileImage,
  }) async {
    try {
      isLoading.value = true;
      final updatedData = await ApiService.updateProfile(
        username: username,
        email: email,
        profileImage: profileImage,
      );
      if (updatedData != null) {
        profileData.value = updatedData;
      }
    } catch (e) {
      print('Error updating profile: $e');
    } finally {
      isLoading.value = false;
    }
  }
}
