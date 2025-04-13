import 'package:flutter/material.dart';

class SchedulePickupScreen extends StatefulWidget {
  const SchedulePickupScreen({super.key});

  @override
  State<SchedulePickupScreen> createState() => _SchedulePickupScreenState();
}

class _SchedulePickupScreenState extends State<SchedulePickupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _addressController = TextEditingController();
  final _notesController = TextEditingController();
  final _phoneController = TextEditingController();

  bool _isSubscribed = false;
  int _unreadNotifications = 3; // Number of unread notifications

  // Collection center messages
  final List<Map<String, dynamic>> _collectionMessages = [
    {
      'id': '1',
      'title': 'Collection Schedule Change',
      'message': 'Due to the upcoming holiday, collection for General Waste will be on Tuesday instead of Monday next week.',
      'date': '2023-06-05',
      'isRead': false,
    },
    {
      'id': '2',
      'title': 'New Recycling Guidelines',
      'message': 'Please note that plastic bags are no longer accepted in the recyclables collection. Use paper bags instead.',
      'date': '2023-06-03',
      'isRead': false,
    },
    {
      'id': '3',
      'title': 'Holiday Collection Hours',
      'message': 'Collection hours will be extended on Friday due to increased volume. Pickup will continue until 5:00 PM.',
      'date': '2023-06-01',
      'isRead': false,
    },
  ];

  // Single collection center data
  final Map<String, dynamic> _collectionCenter = {
    'id': '1',
    'centerName': 'City Waste Management Center',
    'area': 'All Areas',
    'address': '123 Recycling Lane, City Center',
    'phone': '+1 234 567 8900',
    'email': 'info@citywaste.com',
  };

  // Collection schedule for different waste types
  final List<Map<String, dynamic>> _collectionSchedule = [
    {
      'id': '1',
      'wasteType': 'General Waste',
      'day': 'Monday',
      'time': '8:00 AM - 12:00 PM',
      'frequency': 'Weekly',
    },
    {
      'id': '2',
      'wasteType': 'Recyclables',
      'day': 'Wednesday',
      'time': '1:00 PM - 5:00 PM',
      'frequency': 'Weekly',
    },
    {
      'id': '3',
      'wasteType': 'Organic Waste',
      'day': 'Friday',
      'time': '9:00 AM - 2:00 PM',
      'frequency': 'Weekly',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Collection Center'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        actions: [
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.notifications),
                onPressed: () {
                  _showNotificationsDialog(context);
                },
              ),
              if (_unreadNotifications > 0)
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 16,
                      minHeight: 16,
                    ),
                    child: Text(
                      _unreadNotifications.toString(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Collection Center Card
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.location_on,
                          color: Colors.green,
                          size: 28,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            _collectionCenter['centerName'],
                            style: const TextStyle(
                              fontSize: 20,
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
                            color: Colors.green.shade100,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            _collectionCenter['area'],
                            style: const TextStyle(
                              color: Colors.green,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    const Divider(),
                    const SizedBox(height: 8),
                    _buildInfoRow(Icons.location_on, 'Address',
                        _collectionCenter['address']),
                    const SizedBox(height: 8),
                    _buildInfoRow(
                        Icons.phone, 'Phone', _collectionCenter['phone']),
                    const SizedBox(height: 8),
                    _buildInfoRow(
                        Icons.email, 'Email', _collectionCenter['email']),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Collection Schedule',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
            const SizedBox(height: 16),
            // Collection Schedule List
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _collectionSchedule.length,
              itemBuilder: (context, index) {
                final schedule = _collectionSchedule[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 12.0),
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 8.0),
                    leading: CircleAvatar(
                      backgroundColor: Colors.green.shade100,
                      child: Icon(
                        _getWasteTypeIcon(schedule['wasteType']),
                        color: Colors.green,
                      ),
                    ),
                    title: Text(
                      schedule['wasteType'],
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 4),
                        Text('${schedule['day']}s, ${schedule['time']}'),
                        Text('Frequency: ${schedule['frequency']}'),
                      ],
                    ),
                    trailing: ElevatedButton(
                      onPressed: () {
                        _showSubscriptionDialog(context, schedule);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 8),
                      ),
                      child: const Text('ADD MY DETAILS'),
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 24),
            const Text(
              'Important Information',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
            const SizedBox(height: 16),
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '• Please prepare your waste the night before collection day',
                      style: TextStyle(fontSize: 14),
                    ),
                    SizedBox(height: 8),
                    Text(
                      '• Separate your waste according to type (General, Recyclable, Organic)',
                      style: TextStyle(fontSize: 14),
                    ),
                    SizedBox(height: 8),
                    Text(
                      '• Place your waste bins at the curb by 7:00 AM on collection day',
                      style: TextStyle(fontSize: 14),
                    ),
                    SizedBox(height: 8),
                    Text(
                      '• For bulk waste, please contact the center at least 48 hours in advance',
                      style: TextStyle(fontSize: 14),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showNotificationsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            const Icon(Icons.notifications, color: Colors.green),
            const SizedBox(width: 8),
            const Text('Collection Center Messages'),
            const Spacer(),
            if (_unreadNotifications > 0)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  _unreadNotifications.toString(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
          ],
        ),
        content: SizedBox(
          width: double.maxFinite,
          child: _collectionMessages.isEmpty
              ? const Center(
                  child: Text(
                    'No messages available',
                    style: TextStyle(fontSize: 16),
                  ),
                )
              : ListView.builder(
                  shrinkWrap: true,
                  itemCount: _collectionMessages.length,
                  itemBuilder: (context, index) {
                    final message = _collectionMessages[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 8.0),
                      color: message['isRead'] ? Colors.white : Colors.green.shade50,
                      child: ListTile(
                        title: Text(
                          message['title'],
                          style: TextStyle(
                            fontWeight: message['isRead'] ? FontWeight.normal : FontWeight.bold,
                          ),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 4),
                            Text(message['message']),
                            const SizedBox(height: 4),
                            Text(
                              'Date: ${message['date']}',
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                        onTap: () {
                          setState(() {
                            if (!message['isRead']) {
                              message['isRead'] = true;
                              _unreadNotifications--;
                            }
                          });
                          Navigator.pop(context);
                          _showMessageDetails(context, message);
                        },
                      ),
                    );
                  },
                ),
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

  void _showMessageDetails(BuildContext context, Map<String, dynamic> message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(message['title']),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              message['message'],
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            Text(
              'Date: ${message['date']}',
              style: const TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
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

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          size: 20,
          color: Colors.grey,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  IconData _getWasteTypeIcon(String wasteType) {
    switch (wasteType) {
      case 'General Waste':
        return Icons.delete_outline;
      case 'Recyclables':
        return Icons.recycling;
      case 'Organic Waste':
        return Icons.eco;
      default:
        return Icons.category;
    }
  }

  void _showSubscriptionDialog(
      BuildContext context, Map<String, dynamic> schedule) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Your Details'),
        content: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Add your details for ${schedule['wasteType']} collection on ${schedule['day']}s',
                  style: const TextStyle(fontSize: 14),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _addressController,
                  decoration: const InputDecoration(
                    labelText: 'Your Address',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.location_on),
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
                TextFormField(
                  controller: _phoneController,
                  decoration: const InputDecoration(
                    labelText: 'Contact Number',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.phone),
                  ),
                  keyboardType: TextInputType.phone,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your contact number';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _notesController,
                  decoration: const InputDecoration(
                    labelText: 'Additional Notes (Optional)',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.note),
                  ),
                  maxLines: 3,
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Checkbox(
                      value: _isSubscribed,
                      onChanged: (value) {
                        setState(() {
                          _isSubscribed = value ?? false;
                        });
                      },
                      activeColor: Colors.green,
                    ),
                    const Expanded(
                      child: Text(
                        'Subscribe to notifications about collection changes',
                        style: TextStyle(fontSize: 14),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('CANCEL'),
          ),
          ElevatedButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                // TODO: Implement submission logic
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Your details have been added successfully!'),
                    backgroundColor: Colors.green,
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
            ),
            child: const Text('SUBMIT'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _addressController.dispose();
    _notesController.dispose();
    _phoneController.dispose();
    super.dispose();
  }
}
