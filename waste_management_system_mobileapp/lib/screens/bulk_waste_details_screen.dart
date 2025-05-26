// Import packages
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:waste_management_system_mobileapp/models/waste_pickup_model.dart';
import 'package:waste_management_system_mobileapp/providers/user_provider.dart';
import 'package:waste_management_system_mobileapp/providers/waste_provider.dart';

// A screen for scheduling bulk waste pickups
class BulkWasteDetailsScreen extends StatefulWidget {
  const BulkWasteDetailsScreen({super.key});

  @override
  State<BulkWasteDetailsScreen> createState() => _BulkWasteDetailsScreenState();
}

class _BulkWasteDetailsScreenState extends State<BulkWasteDetailsScreen> {
  // Form key for validation
  final _formKey = GlobalKey<FormState>();

  // Controllers for text input fields
  final _descriptionController = TextEditingController();
  final _addressController = TextEditingController();

  // Variables to store form data
  DateTime? _selectedDate;
  String _selectedWasteType = 'Furniture';

  // List of available waste types for the dropdown
  final List<String> _wasteTypes = [
    'Furniture',
    'Electronics',
    'Construction Debris',
    'Garden Waste',
    'Other',
  ];

  //Shows a date picker updates the selected date
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 30)),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  //Validates the form and checks if all required fields are filled
  bool _validateForm() {
    if (_formKey.currentState == null || !_formKey.currentState!.validate()) {
      return false;
    }

    if (_selectedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a pickup date'),
          backgroundColor: Colors.red,
        ),
      );
      return false;
    }

    return true;
  }

  //Processes the form submission and creates a new waste pickup request
  Future<void> _printFormInformation() async {
    if (!_validateForm()) return;

    // Generate a ID for the waste pickup request
    String generateUniqueId() {
      final now = DateTime.now();
      final milliseconds = now.millisecondsSinceEpoch;
      final sixDigits = milliseconds % 1000000;
      return sixDigits.toString().padLeft(6, '0');
    }

    final String pickupId = generateUniqueId();

    // Create a new waste pickup model with form data
    WastePickupModel wastePickup = WastePickupModel(
      title: _selectedWasteType,
      date: Timestamp.fromDate(_selectedDate!),
      userName: context.read<UserProvider>().user!.userName,
      userId: context.read<UserProvider>().user!.userId,
      coordinates: context.read<UserProvider>().user!.locationCordinates,
      address: _addressController.text,
      id: pickupId,
    );

    try {
      // Add the pickup request to the database
      await context.read<WasteProvider>().addBulkPickup(wastePickup);

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Pickup request submitted successfully!'),
          backgroundColor: Colors.green,
        ),
      );

      // Clear form and refresh data
      _descriptionController.clear();
      _selectedDate = null;
      await _featchBulkPickup();
    } catch (e) {
      print('Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error submitting request'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // Fetches the user's bulk pickup requests from the database
  Future<void> _featchBulkPickup() async {
    try {
      await context.read<WasteProvider>().fetchBulkPickups(
        context.read<UserProvider>().user!.userId,
      );
    } catch (e) {
      print('Error fetching bulk pickups: $e');
    }
  }

  @override
  void initState() {
    // Initialize the screen by fetching data and setting default address
    _featchBulkPickup();
    _addressController.text = context.read<UserProvider>().user!.address;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final bulkPickups = context.watch<WasteProvider>().bulkPickups;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Bulk Waste Pickup'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      body:
          context.watch<WasteProvider>().isLoading
              ? Center(
                child: SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(color: Colors.green),
                ),
              )
              : SafeArea(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Request form section
                      Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Schedule Bulk Waste Pickup',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.green,
                              ),
                            ),
                            const SizedBox(height: 24),
                            // Waste type dropdown
                            DropdownButtonFormField<String>(
                              value: _selectedWasteType,
                              decoration: const InputDecoration(
                                labelText: 'Waste Type',
                                border: OutlineInputBorder(),
                                prefixIcon: Icon(Icons.category),
                              ),
                              items:
                                  _wasteTypes.map((String type) {
                                    return DropdownMenuItem<String>(
                                      value: type,
                                      child: Text(type),
                                    );
                                  }).toList(),
                              onChanged: (String? newValue) {
                                if (newValue != null) {
                                  setState(() {
                                    _selectedWasteType = newValue;
                                  });
                                }
                              },
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please select waste type';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 16),
                            // Description text field
                            TextFormField(
                              controller: _descriptionController,
                              decoration: const InputDecoration(
                                labelText: 'Description',
                                border: OutlineInputBorder(),
                                prefixIcon: Icon(Icons.description),
                              ),
                              maxLines: 3,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please describe your waste';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 16),
                            // Address text field
                            TextFormField(
                              controller: _addressController,
                              decoration: const InputDecoration(
                                labelText: 'Pickup Address',
                                border: OutlineInputBorder(),
                                prefixIcon: Icon(Icons.location_on),
                              ),
                              maxLines: 2,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter pickup address';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 16),
                            // Date picker field
                            InkWell(
                              onTap: () => _selectDate(context),
                              child: InputDecorator(
                                decoration: const InputDecoration(
                                  labelText: 'Preferred Pickup Date',
                                  border: OutlineInputBorder(),
                                  prefixIcon: Icon(Icons.calendar_today),
                                ),
                                child: Text(
                                  _selectedDate == null
                                      ? 'Select Date'
                                      : '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}',
                                ),
                              ),
                            ),
                            const SizedBox(height: 24),
                            // Submit button
                            SizedBox(
                              width: double.infinity,
                              height: 50,
                              child: ElevatedButton(
                                onPressed: () {
                                  if (_validateForm()) {
                                    _printFormInformation();
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green,
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                child:
                                    context.watch<WasteProvider>().isLoading
                                        ? SizedBox(
                                          width: 20,
                                          height: 20,
                                          child: CircularProgressIndicator(
                                            color: Colors.white,
                                          ),
                                        )
                                        : const Text(
                                          'SUBMIT REQUEST',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Bulk pickups list section
                      const SizedBox(height: 32),
                      const Divider(),
                      const SizedBox(height: 16),
                      const Text(
                        'Your Bulk Waste Pickup Requests',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Display bulk pickups or a message if none exist
                      bulkPickups.isEmpty
                          ? const Center(
                            child: Padding(
                              padding: EdgeInsets.all(16.0),
                              child: Text(
                                'No bulk waste pickup requests found',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                          )
                          : ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: bulkPickups.length,
                            itemBuilder: (context, index) {
                              final pickup = bulkPickups[index];
                              return Card(
                                elevation: 3,
                                margin: const EdgeInsets.only(bottom: 16),
                                child: Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            pickup.title,
                                            style: const TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 12,
                                              vertical: 6,
                                            ),
                                            decoration: BoxDecoration(
                                              color: Colors.green.shade100,
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                            child: Text(
                                              _formatDate(pickup.date.toDate()),
                                              style: TextStyle(
                                                color: Colors.green.shade800,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 12),
                                      Row(
                                        children: [
                                          const Icon(
                                            Icons.location_on,
                                            color: Colors.grey,
                                            size: 16,
                                          ),
                                          const SizedBox(width: 8),
                                          Expanded(
                                            child: Text(
                                              pickup.address,
                                              style: const TextStyle(
                                                color: Colors.grey,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 8),
                                      Row(
                                        children: [
                                          const Icon(
                                            Icons.person,
                                            color: Colors.grey,
                                            size: 16,
                                          ),
                                          const SizedBox(width: 8),
                                          Text(
                                            pickup.userName,
                                            style: const TextStyle(
                                              color: Colors.grey,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                    ],
                  ),
                ),
              ),
    );
  }

  /// Formats a DateTime object into a string in the format "DD/MM/YYYY"
  String _formatDate(DateTime date) {
    return "${date.day}/${date.month}/${date.year}";
  }

  @override
  void dispose() {
    // Clean up controllers when the widget is disposed
    _descriptionController.dispose();
    _addressController.dispose();
    super.dispose();
  }
}
