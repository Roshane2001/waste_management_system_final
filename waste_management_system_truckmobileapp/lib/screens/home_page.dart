import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:waste_management_system_truckmobileapp/main.dart';
import 'package:waste_management_system_truckmobileapp/providers/location_provider.dart';
import 'package:waste_management_system_truckmobileapp/providers/user_provider.dart';
import 'package:waste_management_system_truckmobileapp/providers/waste_provider.dart';
import 'package:waste_management_system_truckmobileapp/screens/map_screen.dart';
import 'package:waste_management_system_truckmobileapp/screens/call_center_page.dart';
import 'bulk_collections_page.dart';
import 'schedules_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    // Navigate to different pages based on the selected index
    if (index == 1) {
      // Navigate to Collections page
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const BulkCollectionsPage()),
      ).then((_) => setState(() => _selectedIndex = 0));
    } else if (index == 2) {
      // Navigate to Routes/Schedules page
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const SchedulesPage()),
      ).then((_) => setState(() => _selectedIndex = 0));
    }
  }

  Future<void> getUserData() async {
    try {
      final userProvider = context.read<UserProvider>();
      await userProvider.getUserData();
    } catch (e) {
      // Handle error silently or show a snackbar
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to load user data')),
        );
      }
    }
  }

  @override
  void initState() {
    super.initState();
    // Use Future.microtask to avoid setState during build
    Future.microtask(() => getUserData());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Waste Management System'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              context.read<LocationProvider>().clearLocationData();
              await context.read<UserProvider>().logout();
              if (mounted) {
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => const MyApp()),
                  (route) => false,
                );
              }
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
                    // Welcome Message
                    const Text(
                      'Welcome, Driver',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 32),

                    // Main Menu Cards
                    _buildMenuCard(
                      'Bulk Collections',
                      'View and manage today\'s bulk waste collections',
                      Icons.local_shipping,
                      Colors.blue,
                      () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const BulkCollectionsPage(),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 16),
                    _buildMenuCard(
                      'Collection Schedules',
                      'View upcoming collection schedules',
                      Icons.calendar_today,
                      Colors.green,
                      () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SchedulesPage(),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 24),

                    // Quick Actions
                    const Text(
                      'Quick Actions',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildQuickAction(
                          'Start Route',
                          Icons.play_circle_filled,
                          Colors.green,
                          () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const PickupMapScreen(),
                              ),
                            );
                          },
                        ),
                        _buildQuickAction(
                          'View Map',
                          Icons.map,
                          Colors.blue,
                          () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const PickupMapScreen(),
                              ),
                            );
                          },
                        ),
                        _buildQuickAction(
                          'Call Center',
                          Icons.call,
                          Colors.orange,
                          () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const CallCenterPage(),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
            icon: Icon(Icons.list_alt),
            label: 'Collections',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.route), label: 'Routes'),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.green,
        onTap: _onItemTapped,
      ),
    );
  }

  Widget _buildMenuCard(
    String title,
    String subtitle,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return Card(
      elevation: 2,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: color, size: 32),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: TextStyle(color: Colors.grey[600], fontSize: 14),
                    ),
                  ],
                ),
              ),
              Icon(Icons.arrow_forward_ios, color: Colors.grey[400], size: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuickAction(
    String title,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 32),
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}
