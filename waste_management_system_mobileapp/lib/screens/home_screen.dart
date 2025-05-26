import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:waste_management_system_mobileapp/main.dart';
import 'package:waste_management_system_mobileapp/providers/location_provider.dart';
import 'package:waste_management_system_mobileapp/providers/user_provider.dart';
import 'package:waste_management_system_mobileapp/providers/waste_provider.dart';
import 'package:waste_management_system_mobileapp/screens/bulk_waste_details_screen.dart';
import 'package:waste_management_system_mobileapp/screens/complaints_screen.dart';
import 'package:waste_management_system_mobileapp/screens/profile_screen.dart';
import 'package:waste_management_system_mobileapp/screens/recycling_guide_screen.dart';
import 'package:waste_management_system_mobileapp/screens/schedule_pickup_screen.dart';
import 'package:waste_management_system_mobileapp/screens/waste_details_screen.dart';

//The main home screen 
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  //Number of unread notifications
  int _unreadNotifications = 3;

  //Sample collection center messages 
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
  void initState() {
    // Initialize data when the screen loads
    getUserData();
    loadWastePickups();
    _fetchWastePickups();
    super.initState();
  }

  //fetches waste pickup data for the current user
  Future<void> _fetchWastePickups() async {
    final userProvider = context.read<UserProvider>();
    await context.read<WasteProvider>().fetchWastePickups(
      userProvider.user!.userId,
    );
  }

  //Loads user data from the provider
  Future<void> getUserData() async {
    final userProvider = context.read<UserProvider>();
    await userProvider.getUserData();
  }

  //Loads waste pickup data for the current user
  Future<void> loadWastePickups() async {
    final userProvider = context.read<UserProvider>();
    if (userProvider.user != null) {
      await context.read<WasteProvider>().fetchWastePickups(
        userProvider.user!.userId,
      );
    }
  }

  //Returns the appropriate icon and color for different waste types
  Widget _getWasteTypeIndicator(String wasteType) {
    IconData icon;
    Color color;

    if (wasteType.contains('General') || wasteType.contains('Household')) {
      icon = Icons.delete;
      color = Colors.grey;
    } else if (wasteType.contains('Recycl')) {
      icon = Icons.recycling;
      color = Colors.green;
    } else if (wasteType.contains('Organic') || wasteType.contains('Green')) {
      icon = Icons.eco;
      color = Colors.lightGreen;
    } else if (wasteType.contains('Bulk')) {
      icon = Icons.delete_sweep;
      color = Colors.orange;
    } else if (wasteType.contains('Hazard')) {
      icon = Icons.warning;
      color = Colors.red;
    } else {
      icon = Icons.delete_outline;
      color = Colors.blueGrey;
    }

    return CircleAvatar(
      backgroundColor: color,
      child: Icon(icon, color: Colors.white),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Waste Management'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        actions: [
          //Notification icon with unread count badge
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
                      style: const TextStyle(color: Colors.white, fontSize: 10),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ],
          ),
          // Logout button
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => const MyApp()),
                (route) => false,
              );

              Future.delayed(Duration.zero, () {
                context.read<LocationProvider>().clearLocationData();
                context.read<UserProvider>().logout();
              });
            },
          ),
        ],
      ),
      body:
          context.watch<UserProvider>().isLoading ||
                  context.watch<WasteProvider>().isLoading
              ? Center(
                child: SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(color: Colors.green),
                ),
              )
              : SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Welcome Section with user profile
                    Container(
                      padding: const EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        color: Colors.green.shade100,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 40,
                            backgroundColor: Colors.green,
                            backgroundImage: NetworkImage(
                              'https://randomuser.me/api/portraits/men/67.jpg',
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
                                Text(
                                  context.read<UserProvider>().user?.userName ??
                                      'Not Available',
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
                          // Profile navigation button
                          IconButton(
                            icon: Transform.rotate(
                              angle: 3.14159,
                              child: Icon(
                                Icons.arrow_back_ios_rounded,
                                color: Colors.green,
                              ),
                            ),
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
                    // Grid of quick action buttons
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
                                builder:
                                    (context) => const SchedulePickupScreen(),
                              ),
                            );
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
                                builder:
                                    (context) => const BulkWasteDetailsScreen(),
                              ),
                            );
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
                                builder:
                                    (context) => const RecyclingGuideScreen(),
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
                                builder:
                                    (context) => const WasteDetailsScreen(),
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
                    // List of recent waste pickups
                    Consumer<WasteProvider>(
                      builder: (context, wasteProvider, _) {
                        final pickups = wasteProvider.wastePickups;

                        if (wasteProvider.isLoading) {
                          return const Center(
                            child: Padding(
                              padding: EdgeInsets.all(16.0),
                              child: CircularProgressIndicator(
                                color: Colors.green,
                              ),
                            ),
                          );
                        }

                        if (pickups.isEmpty) {
                          return Card(
                            elevation: 2,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Padding(
                              padding: EdgeInsets.all(16.0),
                              child: Center(
                                child: Text(
                                  'No scheduled pickups found',
                                  style: TextStyle(fontSize: 16),
                                ),
                              ),
                            ),
                          );
                        }

                        return ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: pickups.length,
                          itemBuilder: (context, index) {
                            final pickup = pickups[index];
                            return Card(
                              elevation: 2,
                              margin: const EdgeInsets.only(bottom: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: ListTile(
                                contentPadding: const EdgeInsets.all(16),
                                leading: _getWasteTypeIndicator(pickup.title),
                                title: Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        pickup.title,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
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
                                        'ID: ${pickup.id}',
                                        style: const TextStyle(
                                          fontSize: 12,
                                          color: Colors.green,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(height: 8),
                                    Row(
                                      children: [
                                        const Icon(
                                          Icons.calendar_today,
                                          size: 16,
                                          color: Colors.grey,
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          'Scheduled: ${DateFormat('yyyy-MM-dd').format(pickup.date.toDate())}',
                                          style: const TextStyle(fontSize: 14),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 4),
                                    Row(
                                      children: [
                                        const Icon(
                                          Icons.location_on,
                                          size: 16,
                                          color: Colors.grey,
                                        ),
                                        const SizedBox(width: 4),
                                        Expanded(
                                          child: Text(
                                            pickup.address,
                                            style: const TextStyle(
                                              fontSize: 14,
                                            ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),
    );
  }

  //Builds a menu card for quick actions
  Widget _buildMenuCard(
    BuildContext context,
    String title,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 40, color: color),
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

  //Shows the notifications dialog with collection center messages
  void _showNotificationsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Row(
              children: [
                const Icon(Icons.notifications, color: Colors.green),
                const SizedBox(width: 8),
                const Text('Collection Center Messages'),
                const Spacer(),
                if (_unreadNotifications > 0)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
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
              child:
                  _collectionMessages.isEmpty
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
                            color:
                                message['isRead']
                                    ? Colors.white
                                    : Colors.green.shade50,
                            child: ListTile(
                              title: Text(
                                message['title'],
                                style: TextStyle(
                                  fontWeight:
                                      message['isRead']
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

  //Shows detailed view of a collection center message
  void _showMessageDetails(BuildContext context, Map<String, dynamic> message) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text(message['title']),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(message['message'], style: const TextStyle(fontSize: 16)),
                const SizedBox(height: 16),
                Text(
                  'Date: ${message['date']}',
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
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
