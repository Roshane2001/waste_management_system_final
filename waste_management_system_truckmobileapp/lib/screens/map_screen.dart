// project import file paths

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:waste_management_system_truckmobileapp/providers/waste_provider.dart';
import 'package:waste_management_system_truckmobileapp/models/waste_pickup_model.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PickupMapScreen extends StatefulWidget {
  const PickupMapScreen({super.key});

  @override
  _PickupMapScreenState createState() => _PickupMapScreenState();
}

class _PickupMapScreenState extends State<PickupMapScreen> {
  late GoogleMapController _mapController;
  final Set<Marker> _markers = {};
  LatLng? _currentLocation;
  bool _isLoadingLocation = false;

  // Routing related fields
  final Set<Polyline> _polylines = {};
  bool _isCalculatingRoute = false;
  String _routeDistance = "";
  String _routeDuration = "";
  bool _showRouteInfo = false;

  @override
  void initState() {
    super.initState();
    // Load markers after widget is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadMarkers();
      _requestLocationPermission();
    });
  }

  // Request location permission
  Future<void> _requestLocationPermission() async {
    // Location permission handling
    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.whileInUse ||
        permission == LocationPermission.always) {
      _getLocation();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Location permission is required for this feature'),
        ),
      );
    }
  }

  //The current location of device
  Future<void> _getLocation() async {
    setState(() {
      _isLoadingLocation = true;
    });

    try {
      // Cheack if location services are enabled
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        // We can request the service to be enabled
        bool userEnabledService = await Geolocator.openLocationSettings();
        if (!userEnabledService) {
          setState(() {
            _isLoadingLocation = false;
          });
          return;
        }
      }

      // Get current position with Geolocator
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      setState(() {
        _currentLocation = LatLng(position.latitude, position.longitude);
        _isLoadingLocation = false;
      });

      _updateCurrentLocationMarker();

      // Getting the current location
      if (_currentLocation != null) {
        _mapController.animateCamera(CameraUpdate.newLatLng(_currentLocation!));
      }
    } catch (e) {
      setState(() {
        _isLoadingLocation = false;
      });
      print("Error getting location: $e");
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to get current location')));
    }
  }
  
  //location maker on the map
  void _updateCurrentLocationMarker() {
    if (_currentLocation != null) {
      setState(() {
        // change the location added in the map
        _markers.removeWhere(
          (marker) => marker.markerId == MarkerId("current_location"),
        );

        // Add new location marker
        _markers.add(
          Marker(
            markerId: MarkerId("current_location"),
            position: _currentLocation!,
            icon: BitmapDescriptor.defaultMarkerWithHue(
              BitmapDescriptor.hueBlue,
            ),
            infoWindow: InfoWindow(title: "Your Location"),
            zIndex: 2, 
          ),
        );
      });
    }
  }
  
  //loading all waste and bulk pickups into the map
  void _loadMarkers() {
    setState(() {
      _markers.clear();

      // Get waste and bulk pickups from provider
      final wasteProvider = Provider.of<WasteProvider>(context, listen: false);

      // green markers for waste pickups
      for (var pickup in wasteProvider.allWastePickups) {
        _addMarker(
          pickup,
          BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
          "Waste Pickup",
        );
      }

      // yellow markers for bulk pickups
      for (var pickup in wasteProvider.allBulkPickups) {
        _addMarker(
          pickup,
          BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueYellow),
          "Bulk Pickup",
        );
      }

      // Re-adding current location marker if exists
      _updateCurrentLocationMarker();
    });
  }
  
  //adding a single maker to the map for waste pickups
  void _addMarker(WastePickupModel pickup, BitmapDescriptor icon, String type) {
    final marker = Marker(
      markerId: MarkerId(pickup.id),
      position: LatLng(
        pickup.coordinates.latitude,
        pickup.coordinates.longitude,
      ),
      icon: icon,
      infoWindow: InfoWindow(
        title: pickup.title,
        snippet: "$type at ${pickup.address}",
      ),
    );

    _markers.add(marker);
  }
  
  //CALCULATING THE OPTIMAZE ROTE BETWEEN THE ALL LOCATIONS
  Future<void> _calculateRoute() async {
    if (_currentLocation == null) {
      await _getLocation();
      if (_currentLocation == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Unable to get current location')),
        );
        return;
      }
    }

    setState(() {
      _isCalculatingRoute = true;
      _polylines.clear();
      _showRouteInfo = false;
    });

    try {
      final wasteProvider = Provider.of<WasteProvider>(context, listen: false);
      List<WastePickupModel> allPickups = [
        ...wasteProvider.allWastePickups,
        ...wasteProvider.allBulkPickups,
      ];

      if (allPickups.isEmpty) {
        setState(() {
          _isCalculatingRoute = false;
        });
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('No pickup locations to route')));
        return;
      }

      // Starting location
      LatLng startPoint = _currentLocation!;
      List<LatLng> waypointsList = [];

      // Add all pickup points as waypoints
      for (var pickup in allPickups) {
        waypointsList.add(
          LatLng(pickup.coordinates.latitude, pickup.coordinates.longitude),
        );
      }

      // Calculate route 
      final result = await _getDirections(startPoint, waypointsList);

      if (result.isNotEmpty) {
        setState(() {
          _polylines.add(
            Polyline(
              polylineId: PolylineId('route'),
              points: result['points'],
              color: Colors.blue,
              width: 5,
            ),
          );
          _routeDistance = result['distance'];
          _routeDuration = result['duration'];
          _showRouteInfo = true;

          // Fit map to show the entire route
          _fitMapToRoute(result['bounds_ne'], result['bounds_sw']);
                });
      }
    } catch (e) {
      
      print("Error calculating route: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to calculate route. Please try again.')),
      );
    } finally {
      setState(() {
        _isCalculatingRoute = false;
      });
    }
  }

  Future<Map<String, dynamic>> _getDirections(
    LatLng origin,
    List<LatLng> waypoints,
  ) async {

    // GOOGLE API key.
    const apiKey =
        "AIzaSyARK9Lq8gCU2F4kAo9S1vv07b-DA8ZhVMs"; 

    String waypointsString = "";
    if (waypoints.isNotEmpty) {
      List<String> waypointsList =
          waypoints
              .map((point) => "${point.latitude},${point.longitude}")
              .toList();

      // Google Maps API limits waypoints, then can use optimization
      waypointsString = "&waypoints=optimize:true|${waypointsList.join("|")}";
    }

    final url =
        'https://maps.googleapis.com/maps/api/directions/json?'
        'origin=${origin.latitude},${origin.longitude}'
        '&destination=${origin.latitude},${origin.longitude}'
        '$waypointsString'
        '&key=$apiKey';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      if (data['status'] == 'OK') {
        //polyline points
        List<LatLng> polylinePoints = [];
        final routes = data['routes'];

        if (routes.isNotEmpty) {
          final legs = routes[0]['legs'];

          String distance = '';
          String duration = '';

          for (var leg in legs) {
            final steps = leg['steps'];
            final legDistance = leg['distance']['text'];
            final legDuration = leg['duration']['text'];

            if (distance.isEmpty) distance = legDistance;
            if (duration.isEmpty) duration = legDuration;

            for (var step in steps) {
              final points = PolylinePoints().decodePolyline(
                step['polyline']['points'],
              );
              for (var point in points) {
                polylinePoints.add(LatLng(point.latitude, point.longitude));
              }
            }
          }

          // Get bounds from route
          final bounds = routes[0]['bounds'];
          final northeast = bounds['northeast'];
          final southwest = bounds['southwest'];

          return {
            'points': polylinePoints,
            'distance': distance,
            'duration': duration,
            'bounds_ne': LatLng(northeast['lat'], northeast['lng']),
            'bounds_sw': LatLng(southwest['lat'], southwest['lng']),
          };
        }
      } else {
        throw Exception('Directions API error: ${data['status']}');
      }
    }

    throw Exception('Failed to calculate route');
  }
  
  //The map to show the entire route
  void _fitMapToRoute(LatLng northeast, LatLng southwest) {
    _mapController.animateCamera(
      CameraUpdate.newLatLngBounds(
        LatLngBounds(northeast: northeast, southwest: southwest),
        100.0, 
      ),
    );
  }
  
  //clear the route and markers in the map
  void _clearRoute() {
    setState(() {
      _polylines.clear();
      _showRouteInfo = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final wasteProvider = Provider.of<WasteProvider>(context);

    // Show loading indicator to data is being fetched
    if (wasteProvider.isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    // Truck current location to show the first pickup point
    LatLng initialPosition =
        _currentLocation ??
        (wasteProvider.wastePickups.isNotEmpty
            ? LatLng(
              wasteProvider.wastePickups[0].coordinates.latitude,
              wasteProvider.wastePickups[0].coordinates.longitude,
            )
            : const LatLng(6.9271, 79.8612) // Default location Colombo, Sri Lanka
            );

    return Scaffold(
      appBar: AppBar(title: const Text('Pickup Locations')),
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: initialPosition,
              zoom: 12,
            ),
            markers: _markers,
            polylines: _polylines,
            myLocationEnabled: true,
            myLocationButtonEnabled: false,
            onMapCreated: (GoogleMapController controller) {
              _mapController = controller;
              _loadMarkers(); // Refreshing the markers when map is created
            },
          ),
          Positioned(
            bottom: 16.0,
            left: 16.0,
            child: Container(
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8.0),
                boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 8.0)],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Container(width: 20, height: 20, color: Colors.green),
                      const SizedBox(width: 8),
                      const Text('Regular Waste Pickup'),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Container(width: 20, height: 20, color: Colors.yellow),
                      const SizedBox(width: 8),
                      const Text('Bulk Waste Pickup'),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Container(width: 20, height: 20, color: Colors.blue),
                      const SizedBox(width: 8),
                      const Text('Your Location'),
                    ],
                  ),
                  if (_showRouteInfo) ...[
                    const SizedBox(height: 16),
                    const Divider(),
                    const SizedBox(height: 8),
                    Text(
                      'Distance: $_routeDistance',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Duration: $_routeDuration',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ],
              ),
            ),
          ),
          if (_isLoadingLocation || _isCalculatingRoute)
            Positioned(
              top: 16.0,
              right: 16.0,
              child: Container(
                padding: EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8.0),
                  boxShadow: [
                    BoxShadow(color: Colors.black26, blurRadius: 4.0),
                  ],
                ),
                child: CircularProgressIndicator(strokeWidth: 2.0),
              ),
            ),
        ],
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: "location",
            onPressed: _getLocation,
            mini: true,
            child: Icon(Icons.my_location),
          ),
          SizedBox(height: 16.0),
          FloatingActionButton(
            heroTag: "route",
            backgroundColor: _polylines.isNotEmpty ? Colors.red : Colors.orange,
            onPressed: _polylines.isNotEmpty ? _clearRoute : _calculateRoute,
            mini: true,
            child: Icon(
              _polylines.isNotEmpty ? Icons.clear_rounded : Icons.route,
            ),
          ),
          SizedBox(height: 16.0),
          FloatingActionButton(
            heroTag: "refresh",
            child: const Icon(Icons.refresh),
            onPressed: () {
              // Refresh data and markers
              final wasteProvider = Provider.of<WasteProvider>(
                context,
                listen: false,
              );
              wasteProvider.fetchWastePickups('');
              wasteProvider.fetchBulkPickups('');
              _loadMarkers();
              _clearRoute();
            },
          ),
        ],
      ),
    );
  }
}
