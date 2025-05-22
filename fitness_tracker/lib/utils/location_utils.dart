import 'package:geocoding/geocoding.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<String> getAddressFromLatLng(double lat, double lng) async {
  try {
    List<Placemark> placemarks = await placemarkFromCoordinates(
      lat,
      lng,
      localeIdentifier: "en",
    );
    if (placemarks.isNotEmpty) {
      final place = placemarks.first;
      // Format: Street, SubLocality, District, City
      String street = place.street ?? '';
      String subLocality = place.subLocality ?? '';
      String district = place.subAdministrativeArea ?? '';
      String city = place.administrativeArea ?? '';
      String address = [
        street,
        subLocality,
        district,
        city,
      ].where((e) => e.isNotEmpty).join(', ');
      print('Address obtained: $address');
      
      // Save address to SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('last_known_address', address);
      
      return address;
    }
    print('No address found');
    return "Unknown address";
  } catch (e) {
    print('Error getting address: $e');
    return "Error getting address";
  }
}
