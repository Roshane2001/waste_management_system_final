//import packages
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:waste_management_system_mobileapp/models/complaint_model.dart';
import 'package:waste_management_system_mobileapp/providers/location_provider.dart';
import 'package:waste_management_system_mobileapp/providers/user_provider.dart';

//users to submit and view complaints and theri two tabds
class ComplaintsScreen extends StatefulWidget {
  const ComplaintsScreen({super.key});

  @override
  State<ComplaintsScreen> createState() => _ComplaintsScreenState();
}

class _ComplaintsScreenState extends State<ComplaintsScreen> {
  // Form key for validation
  final _formKey = GlobalKey<FormState>();

  // Controllers for text input fields
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _locationController = TextEditingController();

  bool _isLoadingLocation = false;
  String _selectedCategory = 'Service Issue';

  // List of available complaint categories
  final List<String> _categories = [
    'Service Issue',
    'Collection Delay',
    'Missed Pickup',
    'Staff Behavior',
    'Equipment Problem',
    'Other',
  ];

  @override
  void initState() {
    super.initState();
    _getLocation();
    //Fetch complaints when the screen is initialized
    _fetchUserComplaints();
  }

  //Fetches the user's current location and updates the location field
  Future<void> _getLocation() async {
    setState(() {
      _isLoadingLocation = true;
      _locationController.text = 'Fetching location...';
    });

    final locationProvider = Provider.of<LocationProvider>(
      context,
      listen: false,
    );

    try {
      await locationProvider.getLocation();
      setState(() {
        if (locationProvider.getAddress.isNotEmpty) {
          _locationController.text = locationProvider.getAddress;
        } else {
          _locationController.text = 'Location unavailable';
        }
        _isLoadingLocation = false;
      });
    } catch (e) {
      setState(() {
        _locationController.text = 'Error fetching location';
        _isLoadingLocation = false;
      });
      print('Error getting location: $e');
    }
  }

  //Fetches the user's complaints from the database
  Future<void> _fetchUserComplaints() async {
    try {
      await Provider.of<UserProvider>(context, listen: false).fetchComplaints();
    } catch (e) {
      print('Error fetching complaints: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Complaints'),
          backgroundColor: Colors.green,
          foregroundColor: Colors.white,
          bottom: const TabBar(
            indicatorColor: Colors.white,
            tabs: [Tab(text: 'My Complaints'), Tab(text: 'New Complaint')],
          ),
        ),
        body: TabBarView(
          children: [
            // My Complaints Tab
            _buildComplaintsList(),

            // New Complaint Tab
            _buildNewComplaintForm(),
          ],
        ),
      ),
    );
  }

  //the list view of user's complaints
  Widget _buildComplaintsList() {
    final userProvider = Provider.of<UserProvider>(context);

    if (userProvider.isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: Colors.green),
      );
    }

    if (userProvider.complaints == null || userProvider.complaints!.isEmpty) {
      return const Center(
        child: Text(
          'No complaints submitted yet',
          style: TextStyle(fontSize: 16),
        ),
      );
    }

    // Filter complaints to show only the current user's complaints
    final userComplaints =
        userProvider.complaints!
            .where((complaint) => complaint.userId == userProvider.user!.userId)
            .toList();

    if (userComplaints.isEmpty) {
      return const Center(
        child: Text(
          'You haven\'t submitted any complaints yet',
          style: TextStyle(fontSize: 16),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: userComplaints.length,
      itemBuilder: (context, index) {
        final complaint = userComplaints[index];
        // Format the timestamp to a readable date string
        final submittedDate = DateTime.fromMillisecondsSinceEpoch(
          complaint.submittedDateTime.seconds * 1000,
        ).toString().substring(0, 10);

        return Card(
          margin: const EdgeInsets.only(bottom: 16.0),
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        complaint.title,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.orange, // Default to In Progress
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Text(
                        'In Progress', // Default status
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  complaint.description,
                  style: const TextStyle(fontSize: 14),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.category, size: 16, color: Colors.grey),
                    const SizedBox(width: 4),
                    Text(
                      complaint.category,
                      style: const TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                    const SizedBox(width: 16),
                    const Icon(Icons.location_on, size: 16, color: Colors.grey),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        complaint.location,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Submitted: $submittedDate',
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                    TextButton(
                      onPressed: () {
                        _showComplaintDetails(complaint);
                      },
                      child: const Text('View Details'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  //the form for submitting new complaints
  Widget _buildNewComplaintForm() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Submit a New Complaint',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
            const SizedBox(height: 24),
            // Category dropdown
            DropdownButtonFormField<String>(
              value: _selectedCategory,
              decoration: const InputDecoration(
                labelText: 'Complaint Category',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.category),
              ),
              items:
                  _categories.map((String category) {
                    return DropdownMenuItem<String>(
                      value: category,
                      child: Text(category),
                    );
                  }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _selectedCategory = newValue!;
                });
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please select a category';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            // Title input field
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Complaint Title',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.title),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a title';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            // Description input field
            TextFormField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'Description',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.description),
              ),
              maxLines: 4,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a description';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            //Location input field with location fetching
            TextFormField(
              controller: _locationController,
              decoration: InputDecoration(
                labelText: 'Location',
                border: const OutlineInputBorder(),
                prefixIcon: const Icon(Icons.location_on),
                suffixIcon:
                    _isLoadingLocation
                        ? const SizedBox(
                          height: 10,
                          width: 10,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.green,
                          ),
                        )
                        : IconButton(
                          icon: const Icon(Icons.my_location),
                          onPressed: _getLocation,
                          tooltip: 'Get current location',
                        ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a location';
                }
                return null;
              },
            ),
            const SizedBox(height: 24),
            //Submit button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _submitComplaint,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child:
                    context.watch<UserProvider>().isLoading
                        ? SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(color: Colors.white),
                        )
                        : const Text(
                          'SUBMIT COMPLAINT',
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
    );
  }

  //Submits the complaint form data to the database
  Future<void> _submitComplaint() async {
    if (_formKey.currentState!.validate()) {
      //Print form data for debugging
      _printFormData();

      // Generate a unique 6-character ID based on current date and time
      String generateUniqueId() {
        final now = DateTime.now();
        final timestamp = now.millisecondsSinceEpoch;
        final encodedId = timestamp.toRadixString(36);
        return encodedId.substring(encodedId.length - 6);
      }

      // Create complaint model with form data
      ComplaintModel complaint = ComplaintModel(
        complaintId: generateUniqueId(),
        category: _selectedCategory,
        title: _titleController.text,
        description: _descriptionController.text,
        location: _locationController.text,
        userName: context.read<UserProvider>().user!.userName,
        userId: context.read<UserProvider>().user!.userId,
        submittedDateTime: Timestamp.fromDate(DateTime.now()),
      );

      try {
        // Submit complaint to database
        await context.read<UserProvider>().createComplaint(complaint);

        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Complaint submitted successfully!'),
            backgroundColor: Colors.green,
          ),
        );

        //Clear form fields
        _titleController.clear();
        _descriptionController.clear();
        setState(() {
          _selectedCategory = 'Service Issue';
        });
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Error submitting complaint. Please try again.'),
            backgroundColor: Colors.red,
          ),
        );
        print('Error submitting complaint: $e');
      }
    }
  }

  //Prints form data for debugging purposes
  void _printFormData() {
    print('==== COMPLAINT FORM DATA ====');
    print('Category: $_selectedCategory');
    print('Title: ${_titleController.text}');
    print('Description: ${_descriptionController.text}');
    print('Location: ${_locationController.text}');
    print('============================');
  }

  //Shows a dialog with detailed complaint information
  void _showComplaintDetails(ComplaintModel complaint) {
    final submittedDate = DateTime.fromMillisecondsSinceEpoch(
      complaint.submittedDateTime.seconds * 1000,
    ).toString().substring(0, 10);

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text(complaint.title),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Category: ${complaint.category}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Description:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(complaint.description),
                const SizedBox(height: 8),
                Text(
                  'Location: ${complaint.location}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  'Status: In Progress',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  'Submitted: $submittedDate',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('CLOSE'),
              ),
            ],
          ),
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _locationController.dispose();
    super.dispose();
  }
}
