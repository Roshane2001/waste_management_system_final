import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:waste_management_system_truckmobileapp/providers/user_provider.dart';
import 'package:waste_management_system_truckmobileapp/providers/waste_provider.dart';
import 'package:waste_management_system_truckmobileapp/models/waste_pickup_model.dart';
import 'package:intl/intl.dart';

class SchedulesPage extends StatefulWidget {
  const SchedulesPage({super.key});

  @override
  State<SchedulesPage> createState() => _SchedulesPageState();
}

class _SchedulesPageState extends State<SchedulesPage> {
  Future<void> _fetchWastePickups() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    await context.read<WasteProvider>().fetchWastePickups(
      userProvider.user!.userId,
    );
  }

  @override
  void initState() {
    _fetchWastePickups();
    super.initState();
  }

  // Group waste pickups by date
  Map<String, List<WastePickupModel>> _groupPickupsByDate(
    List<WastePickupModel> pickups,
  ) {
    final Map<String, List<WastePickupModel>> grouped = {};

    for (var pickup in pickups) {
      final dateStr = DateFormat('EEEE, MMMM d').format(pickup.date.toDate());

      if (!grouped.containsKey(dateStr)) {
        grouped[dateStr] = [];
      }

      grouped[dateStr]!.add(pickup);
    }

    return grouped;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Collection Schedules'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      body:
          context.watch<WasteProvider>().isLoading
              ? const Center(
                child: SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(color: Colors.green),
                ),
              )
              : Consumer<WasteProvider>(
                builder: (context, wasteProvider, child) {
                  if (wasteProvider.wastePickups.isEmpty) {
                    return const Center(
                      child: Text('No upcoming collections scheduled'),
                    );
                  }

                  final groupedPickups = _groupPickupsByDate(
                    wasteProvider.wastePickups,
                  );

                  return SingleChildScrollView(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Upcoming Collections',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        ...groupedPickups.entries.map((entry) {
                          return _buildScheduleItem(entry.key, entry.value);
                        }),
                      ],
                    ),
                  );
                },
              ),
    );
  }

  Widget _buildScheduleItem(String date, List<WastePickupModel> pickups) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.calendar_today, color: Colors.green[700], size: 20),
                const SizedBox(width: 8),
                Text(
                  date,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const Divider(height: 24),
            ...pickups.map((pickup) {
              final time = DateFormat('h:mm a').format(pickup.date.toDate());
              return _buildTimeSlot(time, pickup.title, pickup.address);
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeSlot(String time, String type, String location) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        children: [
          SizedBox(
            width: 64,
            child: Text(
              time,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.green,
              ),
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(type, style: const TextStyle(fontWeight: FontWeight.w500)),
                Text(
                  'Location: $location',
                  style: TextStyle(color: Colors.grey[600], fontSize: 12),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
