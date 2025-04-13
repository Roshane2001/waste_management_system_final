import 'package:flutter/material.dart';
import 'package:waste_management_system_mobileapp/screens/bulk_waste_details_screen.dart';
import 'package:waste_management_system_mobileapp/screens/complaints_screen.dart';
import 'package:waste_management_system_mobileapp/screens/profile_screen.dart';
import 'package:waste_management_system_mobileapp/screens/recycling_guide_screen.dart';
import 'package:waste_management_system_mobileapp/screens/schedule_pickup_screen.dart';
import 'package:waste_management_system_mobileapp/screens/waste_details_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _unreadNotifications = 3; // Number of unread notifications

  // Collection center messages
  final List<Map<String, dynamic>> _collectionMessages = [
    {
      'id': '1',
      'title': 'Collection Schedule Change',
      'message':
          'Due to the upcoming holiday, collection for General Waste will be on Tuesday instead of Monday next week.',
      'date': '2023-06-05',
      'isRead': false,
    },
    {
      'id': '2',
      'title': 'New Recycling Guidelines',
      'message':
          'Please note that plastic bags are no longer accepted in the recyclables collection. Use paper bags instead.',
      'date': '2023-06-03',
      'isRead': false,
    },
    {
      'id': '3',
      'title': 'Holiday Collection Hours',
      'message':
          'Collection hours will be extended on Friday due to increased volume. Pickup will continue until 5:00 PM.',
      'date': '2023-06-01',
      'isRead': false,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Waste Management'),
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
            // Welcome Section
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.green.shade100,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  const CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.green,
                    child: Icon(
                      Icons.person,
                      size: 40,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Welcome,',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                          ),
                        ),
                        const Text(
                          'John Doe',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Resident ID: RES123456',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade700,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.edit, color: Colors.green),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ProfileScreen(),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            // Quick Actions Section
            const Text(
              'Quick Actions',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
            const SizedBox(height: 16),
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 16.0,
              crossAxisSpacing: 16.0,
              children: [
                _buildMenuCard(
                  context,
                  'Schedule Pickup',
                  Icons.calendar_today,
                  Colors.blue,
                  () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                const SchedulePickupScreen()));
                  },
                ),
                _buildMenuCard(
                  context,
                  'Bulk Waste',
                  Icons.delete_sweep,
                  Colors.orange,
                  () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                const BulkWasteDetailsScreen()));
                  },
                ),
                _buildMenuCard(
                  context,
                  'Recycling Guide',
                  Icons.recycling,
                  Colors.green,
                  () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const RecyclingGuideScreen(),
                      ),
                    );
                  },
                ),
                _buildMenuCard(
                  context,
                  'Complaints',
                  Icons.report_problem,
                  Colors.red,
                  () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ComplaintsScreen(),
                      ),
                    );
                  },
                ),
                _buildMenuCard(
                  context,
                  'Waste Details',
                  Icons.analytics,
                  Colors.teal,
                  () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const WasteDetailsScreen(),
                      ),
                    );
                  },
                ),
                _buildMenuCard(
                  context,
                  'Truck Tracking',
                  Icons.local_shipping,
                  Colors.purple,
                  () {
                    // TODO: Navigate to Truck Tracking Screen
                  },
                ),
              ],
            ),
            const SizedBox(height: 24),
            // Recent Activity Section
            const Text(
              'Recent Activity',
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
              child: const ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.green,
                  child: Icon(
                    Icons.check_circle,
                    color: Colors.white,
                  ),
                ),
                title: Text('Waste Collection Completed'),
                subtitle: Text('General Waste - June 5, 2023'),
                trailing: Text(
                  'Completed',
                  style: TextStyle(
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              child: const ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.orange,
                  child: Icon(
                    Icons.pending,
                    color: Colors.white,
                  ),
                ),
                title: Text('Bulk Waste Pickup Scheduled'),
                subtitle: Text('June 10, 2023'),
                trailing: Text(
                  'Pending',
                  style: TextStyle(
                    color: Colors.orange,
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

  Widget _buildMenuCard(BuildContext context, String title, IconData icon,
      Color color, VoidCallback onTap) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 40,
                color: color,
              ),
              const SizedBox(height: 12),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
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
                      color: message['isRead']
                          ? Colors.white
                          : Colors.green.shade50,
                      child: ListTile(
                        title: Text(
                          message['title'],
                          style: TextStyle(
                            fontWeight: message['isRead']
                                ? FontWeight.normal
                                : FontWeight.bold,
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
}
