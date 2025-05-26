//import project packages
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:waste_management_system_truckmobileapp/services/location_services.dart';

/// LocationProvider class to managing location data
class LocationProvider extends ChangeNotifier {
  double latitude = 0.0;
  double longitude = 0.0;
  String address = '';

  bool isLoading = false;
  
  final _locationService = LocationServices();
  
  double get getLatitude => latitude;
  double get getLongitude => longitude;
  String get getAddress => address;

  void updateLocation(double lat, double long) {
    latitude = lat;
    longitude = long;
    notifyListeners();
  }
  // Update new location data
  void updateLocationData({
    required double lat,
    required double long,
    required String newAddress,
  }) {
    latitude = lat;
    longitude = long;
    address = newAddress;
    notifyListeners();
  }

  // Get current location
  Future<void> getLocation() async {
    isLoading = true;
    notifyListeners();

    try {
      final results = await _locationService.getCurrentLocation();
      if (results != null) {
        latitude = results.latitude;
        longitude = results.longitude;

        // Get address from coordinates
        List<Placemark> placemarks = await placemarkFromCoordinates(
          latitude,
          longitude,
        );
        if (placemarks.isNotEmpty) {
          Placemark place = placemarks.first;
          address = '${place.street}, ${place.locality}, ${place.country}';
        }
      } else {
        print("Location not available");
      }
    } catch (e) {
      print("Error getting location: $e");
    }

    isLoading = false;
    notifyListeners();
  }
  
  
  void clearLocationData() {
    latitude = 0.0;
    longitude = 0.0;
    address = '';
    notifyListeners();
  }
}
