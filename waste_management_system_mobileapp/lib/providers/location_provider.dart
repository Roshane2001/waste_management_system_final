import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:waste_management_system_mobileapp/services/location_services.dart';

/// A provider class that manages location-related state and operations
/// Uses ChangeNotifier to notify listeners of location updates
class LocationProvider extends ChangeNotifier {
  // Location coordinates
  double latitude = 0.0;
  double longitude = 0.0;
  // Human-readable address string
  String address = '';

  // Loading state indicator
  bool isLoading = false;

  // Instance of location services
  final _locationService = LocationServices();

  // Getters for location data
  double get getLatitude => latitude;
  double get getLongitude => longitude;
  String get getAddress => address;

  /// Updates only the coordinates without fetching address
  void updateLocation(double lat, double long) {
    latitude = lat;
    longitude = long;
    notifyListeners();
  }

  /// Updates both coordinates and address information
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

  /// Fetches current location and converts coordinates to address
  /// Updates the provider state with location data
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

  /// Resets all location data to default values
  void clearLocationData() {
    latitude = 0.0;
    longitude = 0.0;
    address = '';
    notifyListeners();
  }
}
