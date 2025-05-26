// Import required packages
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:waste_management_system_mobileapp/main.dart';
import 'package:waste_management_system_mobileapp/models/user_model.dart';
import 'package:waste_management_system_mobileapp/providers/location_provider.dart';
import 'package:waste_management_system_mobileapp/providers/user_provider.dart';
import 'package:waste_management_system_mobileapp/screens/map_screen.dart';

//A screen for user registration in the waste management application.
class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  //Form key for validation
  final _formKey = GlobalKey<FormState>();
  
  //Controllers for text input fields
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _addressController = TextEditingController();
  final _postalCodeController = TextEditingController();
  final _phoneController = TextEditingController();
  
  //State variables for password visibility
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  //Handles the user registration process
  //Creates a new user account and navigates to the main app on success
  Future<void> _handleSignUp() async {
    if (_formKey.currentState!.validate()) {
      try {
        //Get location data from provider
        final locationProvider = context.read<LocationProvider>();
        
        //Create user model with form data
        UserModel user = UserModel(
          userId: "",
          userName: _nameController.text,
          userEmail: _emailController.text,
          registeredDateTime: DateTime.now(),
          lastUpdatedDateTime: DateTime.now(),
          locationCordinates: GeoPoint(
            locationProvider.latitude,
            locationProvider.longitude,
          ),
          userPhoneNumber: _phoneController.text,
          userType: "User",
          address: _addressController.text,
        );

        // Register user with Firebase
        await context.read<UserProvider>().registerUser(
          user,
          _passwordController.text,
        );

        // Navigate to main app on success
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const MyApp()),
          (route) => false,
        );
      } catch (error) {
        // Show error message on failure
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Registration failed: ${error.toString()}',
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor: Color.fromARGB(255, 207, 79, 79),
          ),
        );
      }
    }
  }

  //Gets the user's current location and updates the address field
  Future<void> _getCurrentLocation() async {
    await context.read<LocationProvider>().getLocation();

    if (context.read<LocationProvider>().latitude != 0.0 &&
        context.read<LocationProvider>().longitude != 0.0) {
      _addressController.text = context.read<LocationProvider>().address;
      setState(() {});
    }
  }

  //Opens the map screen for location selection
  //Updates the address field with the selected location
  Future<void> _openMapScreen() async {
    final result = await Navigator.of(context).push<Map<String, dynamic>>(
      MaterialPageRoute(builder: (context) => const MapScreen()),
    );

    if (result != null) {
      context.read<LocationProvider>().updateLocationData(
        lat: result['latitude'],
        long: result['longitude'],
        newAddress: result['address'],
      );
      _addressController.text = result['address'];
      setState(() {}); // Refresh UI to update location image
    }
  }

  //Generates a static map image URL for the selected location
  String get locationImage {
    final locationProvider = context.read<LocationProvider>();
    return "https://maps.googleapis.com/maps/api/staticmap?center=${locationProvider.latitude},${locationProvider.longitude}&zoom=17&size=600x300&maptype=roadmap&markers=color:red%7Clabel:A%7C${locationProvider.latitude},${locationProvider.longitude}&key=AIzaSyARK9Lq8gCU2F4kAo9S1vv07b-DA8ZhVMs";
  }

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  //Builds the location selection section with map preview
  Widget _buildLocationSection() {
    final locationProvider = context.watch<LocationProvider>();

    // Show loading indicator while fetching location
    if (locationProvider.isLoading) {
      return const Center(
        child: SizedBox(
          height: 100,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              LinearProgressIndicator(color: Colors.black),
              SizedBox(height: 8),
              Text('Fetching location...'),
            ],
          ),
        ),
      );
    }

    // Location preview and change button
    return Column(
      children: [
        // Static map preview
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            image: DecorationImage(
              image: NetworkImage(locationImage),
              fit: BoxFit.cover,
            ),
          ),
          height: 200,
          width: double.infinity,
        ),
        const SizedBox(height: 8),
        // Change location button
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: _openMapScreen,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: Color(0xFF36454F),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
                side: const BorderSide(color: Color(0xFF36454F), width: 1.5),
              ),
            ),
            child: const Text("Change Location"),
          ),
        ),
        const SizedBox(height: 8),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // App logo
                Image.asset('assets/logo.png', height: 100, width: 100),
                const SizedBox(height: 32),
                
                // Registration title
                const Text(
                  'Create Account',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),

                // Personal Information Fields
                // Name Field
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: 'Full Name',
                    prefixIcon: const Icon(Icons.person),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Address Field
                TextFormField(
                  controller: _addressController,
                  decoration: InputDecoration(
                    labelText: 'Address',
                    prefixIcon: const Icon(Icons.location_on),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  maxLines: 2,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your address';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Postal Code Field
                TextFormField(
                  controller: _postalCodeController,
                  decoration: InputDecoration(
                    labelText: 'Postal Code',
                    prefixIcon: const Icon(Icons.markunread_mailbox),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter postal code';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Phone Field
                TextFormField(
                  controller: _phoneController,
                  decoration: InputDecoration(
                    labelText: 'Phone Number',
                    prefixIcon: const Icon(Icons.phone),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  keyboardType: TextInputType.phone,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your phone number';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Email Field
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    prefixIcon: const Icon(Icons.email),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    }
                    if (!value.contains('@')) {
                      return 'Please enter a valid email';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                
                // Location Selection Section
                _buildLocationSection(),
                const SizedBox(height: 16),

                // Security Fields
                // Password Field
                TextFormField(
                  controller: _passwordController,
                  obscureText: !_isPasswordVisible,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    prefixIcon: const Icon(Icons.lock),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isPasswordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(() {
                          _isPasswordVisible = !_isPasswordVisible;
                        });
                      },
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a password';
                    }
                    if (value.length < 6) {
                      return 'Password must be at least 6 characters';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Confirm Password Field
                TextFormField(
                  controller: _confirmPasswordController,
                  obscureText: !_isConfirmPasswordVisible,
                  decoration: InputDecoration(
                    labelText: 'Confirm Password',
                    prefixIcon: const Icon(Icons.lock_outline),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isConfirmPasswordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(() {
                          _isConfirmPasswordVisible =
                              !_isConfirmPasswordVisible;
                        });
                      },
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please confirm your password';
                    }
                    if (value != _passwordController.text) {
                      return 'Passwords do not match';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),

                // Register Button
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _handleSignUp();
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Please fill all fields correctly'),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child:
                      context.watch<UserProvider>().isLoading
                          ? SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                            ),
                          )
                          : const Text(
                            'REGISTER',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                ),
                const SizedBox(height: 16),

                // Login Link
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Already have an account?'),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text(
                        'Login',
                        style: TextStyle(color: Colors.green),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    // Clean up controllers when the widget is disposed
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _addressController.dispose();
    _postalCodeController.dispose();
    _phoneController.dispose();
    super.dispose();
  }
}
