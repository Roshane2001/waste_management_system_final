import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'dart:async';

/// A screen that displays a Google Map for location selection.

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  // Map controller for camera and map operations
  GoogleMapController? _mapController;
  
  // Initial map position (will be updated with current location)
  LatLng _initialPosition = const LatLng(0, 0);
  
  // Loading state for initial map setup
  bool _isLoading = true;
  
  // Set of markers to display on the map
  final Set<Marker> _markers = {};
  
  // Controller for the search text field
  final TextEditingController _searchController = TextEditingController();

  // Search suggestions state management
  List<String> _suggestions = [];
  bool _isSearching = false;
  Timer? _debounce;
  final FocusNode _focusNode = FocusNode();
  bool _showSuggestions = false;

  // Loading state for search operations
  bool _isSearchLoading = false;

  @override
  void initState() {
    super.initState();
    // Get current location when screen initializes
    _getCurrentLocation();

    // Add listener for search text changes
    _searchController.addListener(_onSearchChanged);

    // Add listener for focus changes to show/hide suggestions
    _focusNode.addListener(() {
      setState(() {
        _showSuggestions = _focusNode.hasFocus && _suggestions.isNotEmpty;
      });
    });
  }

  @override
  void dispose() {
    // Clean up controllers and listeners
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    _debounce?.cancel();
    _focusNode.dispose();
    super.dispose();
  }

  //Handles search text changes with debouncing
  void _onSearchChanged() {
    if (_debounce?.isActive ?? false) _debounce!.cancel();

    _debounce = Timer(const Duration(milliseconds: 500), () {
      if (_searchController.text.length > 2) {
        _getSuggestions(_searchController.text);
      } else {
        setState(() {
          _suggestions = [];
          _showSuggestions = false;
        });
      }
    });
  }

  //Gets location suggestions based on user input
  //Uses geocoding to convert addresses to coordinates and back
  Future<void> _getSuggestions(String input) async {
    if (input.isEmpty) return;

    setState(() {
      _isSearching = true;
    });

    try {
      //Get location suggestions using the geocoding package
      List<Location> locations = await locationFromAddress(
        input,
        localeIdentifier: 'en_LK',
      );

      //Convert locations to address strings (reverse geocoding)
      List<String> suggestions = [];
      for (var location in locations) {
        List<Placemark> placemarks = await placemarkFromCoordinates(
          location.latitude,
          location.longitude,
        );

        if (placemarks.isNotEmpty) {
          Placemark place = placemarks.first;
          String address = '${place.name}, ${place.locality}, ${place.country}';
          if (!suggestions.contains(address)) {
            suggestions.add(address);
          }
        }
      }

      //Add some artificial suggestions for testing
      if (suggestions.isEmpty) {
        suggestions = [
          '$input Road, Colombo',
          '$input Street, Kandy',
          '$input Avenue, Galle',
        ];
      }

      setState(() {
        _suggestions = suggestions.take(5).toList(); // Limit to 5 suggestions. more than can be laged
        _showSuggestions = _suggestions.isNotEmpty && _focusNode.hasFocus;
        _isSearching = false;
      });
    } catch (e) {
      print('Error getting suggestions: $e');
      setState(() {
        _isSearching = false;
        _suggestions = [];
        _showSuggestions = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        title: const Text(
          'Pick a Location',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.black,
      ),
      body: Stack(
        children: [
          // Show loading indicator while initializing map
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : Stack(
                children: [
                  // Google Map widget
                  GoogleMap(
                    initialCameraPosition: CameraPosition(
                      target: _initialPosition,
                      zoom: 15,
                    ),
                    myLocationEnabled: true,
                    myLocationButtonEnabled: false,
                    mapType: MapType.normal,
                    zoomControlsEnabled: false,
                    onMapCreated: (GoogleMapController controller) {
                      _mapController = controller;
                    },
                    markers: _markers,
                    onTap: (_) {
                      // Close suggestions when tapping on map
                      _focusNode.unfocus();
                      setState(() {
                        _showSuggestions = false;
                      });
                    },
                    onLongPress: _handleMapLongPress,
                  ),
                  // Search box with suggestions
                  Positioned(
                    top: 10,
                    left: 15,
                    right: 15,
                    child: Column(
                      children: [
                        // Search input field
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 2,
                                blurRadius: 7,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Center(
                            child: TextField(
                              controller: _searchController,
                              focusNode: _focusNode,
                              textInputAction: TextInputAction.search,
                              decoration: InputDecoration(
                                hintText: 'Search location...',
                                border: InputBorder.none,
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 15,
                                ),
                                suffixIcon:
                                    _isSearching
                                        ? Container(
                                          padding: const EdgeInsets.all(10),
                                          height: 10,
                                          width: 10,
                                          child:
                                              const CircularProgressIndicator(
                                                strokeWidth: 2,
                                              ),
                                        )
                                        : IconButton(
                                          icon: const Icon(Icons.search),
                                          onPressed: () {
                                            _searchPlace(
                                              _searchController.text,
                                            );
                                            _focusNode.unfocus();
                                            setState(() {
                                              _showSuggestions = false;
                                            });
                                          },
                                        ),
                              ),
                              onSubmitted: (value) {
                                _searchPlace(value);
                                setState(() {
                                  _showSuggestions = false;
                                });
                              },
                            ),
                          ),
                        ),

                        // Suggestions list
                        if (_showSuggestions)
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  spreadRadius: 2,
                                  blurRadius: 7,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            margin: const EdgeInsets.only(top: 5),
                            child: ListView.separated(
                              padding: EdgeInsets.zero,
                              shrinkWrap: true,
                              itemCount: _suggestions.length,
                              separatorBuilder:
                                  (_, __) => const Divider(height: 1),
                              itemBuilder: (context, index) {
                                return ListTile(
                                  leading: const Icon(
                                    Icons.location_on,
                                    color: Colors.red,
                                  ),
                                  title: Text(_suggestions[index]),
                                  dense: true,
                                  onTap: () {
                                    _searchController.text =
                                        _suggestions[index];
                                    _searchPlace(_suggestions[index]);
                                    _focusNode.unfocus();
                                    setState(() {
                                      _showSuggestions = false;
                                    });
                                  },
                                );
                              },
                            ),
                          ),
                      ],
                    ),
                  ),
                  // Confirmation button when location is selected
                  if (_markers.isNotEmpty)
                    Positioned(
                      bottom: 20,
                      left: 20,
                      right: 20,
                      child: SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black,
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            elevation: 5,
                          ),
                          onPressed: () {
                            // Get the first marker's position
                            final marker = _markers.first;
                            Navigator.pop(context, {
                              'latitude': marker.position.latitude,
                              'longitude': marker.position.longitude,
                              'address': marker.infoWindow.title,
                            });
                          },
                          child: const Text(
                            'Pick and Confirm Location\n(Long press on the map to select a location)',
                            style: TextStyle(color: Colors.white),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
          // Loading overlay during search
          if (_isSearchLoading)
            Container(
              color: Colors.black54,
              child: const Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircularProgressIndicator(color: Colors.white),
                    SizedBox(height: 16),
                    Text(
                      'Searching location...',
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  /// Gets the user's current location and updates the map
  /// Handles location permissions and error cases
  Future<void> _getCurrentLocation() async {
    try {
      // Check for location permissions
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        return;
      }

      // Get current position
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      setState(() {
        _initialPosition = LatLng(position.latitude, position.longitude);
        _isLoading = false;
        _markers.add(
          Marker(
            markerId: const MarkerId('currentLocation'),
            position: _initialPosition,
            infoWindow: const InfoWindow(title: 'Current Location'),
          ),
        );
      });

      _mapController?.animateCamera(
        CameraUpdate.newLatLngZoom(_initialPosition, 15),
      );
    } catch (e) {
      print("Error getting location: $e");
    }
  }

  /// Searches for a location based on the provided address
  /// Updates the map with the search result and returns location data
  Future<void> _searchPlace(String address) async {
    if (address.isEmpty) return;

    setState(() {
      _isSearchLoading = true;
    });

    try {
      List<Location> locations = await locationFromAddress(address);

      if (locations.isNotEmpty) {
        Location location = locations.first;
        LatLng latLng = LatLng(location.latitude, location.longitude);

        setState(() {
          _markers.clear();
          _markers.add(
            Marker(
              markerId: const MarkerId('searchResult'),
              position: latLng,
              infoWindow: InfoWindow(title: address),
            ),
          );
        });

        _mapController?.animateCamera(CameraUpdate.newLatLngZoom(latLng, 15));

        // Return selected location data to previous screen
        Navigator.pop(context, {
          'latitude': location.latitude,
          'longitude': location.longitude,
          'address': address,
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not find the location: $e')),
      );
    } finally {
      setState(() {
        _isSearchLoading = false;
      });
    }
  }

  //Long press on the map to select a location
  //Performs reverse geocoding to get the address
  Future<void> _handleMapLongPress(LatLng position) async {
    try {
      //Get address from coordinates (reverse geocoding)
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks.first;
        String address = '${place.street}, ${place.locality}, ${place.country}';

        setState(() {
          _markers.clear();
          _markers.add(
            Marker(
              markerId: const MarkerId('selectedLocation'),
              position: position,
              infoWindow: InfoWindow(title: address),
            ),
          );
        });

        // Update search controller text
        _searchController.text = address;
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to get address for selected location'),
        ),
      );
    }
  }
}
