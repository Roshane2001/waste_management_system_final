import 'package:flutter/material.dart';

class SchedulesPage extends StatelessWidget {
  const SchedulesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Collection Schedules'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
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
            _buildScheduleItem(
              'Monday, March 25',
              [
                _buildTimeSlot('9:00 AM', 'Construction Waste', '2.5 tons'),
                _buildTimeSlot('2:00 PM', 'Industrial Waste', '1.8 tons'),
              ],
            ),
            _buildScheduleItem(
              'Tuesday, March 26',
              [
                _buildTimeSlot('10:30 AM', 'Commercial Waste', '3.0 tons'),
                _buildTimeSlot('3:30 PM', 'Construction Waste', '2.2 tons'),
              ],
            ),
            _buildScheduleItem(
              'Wednesday, March 27',
              [
                _buildTimeSlot('8:00 AM', 'Industrial Waste', '2.7 tons'),
                _buildTimeSlot('1:00 PM', 'Commercial Waste', '1.5 tons'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildScheduleItem(String date, List<Widget> timeSlots) {
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
            ...timeSlots,
          ],
        ),
      ),
    );
  }

  Widget _buildTimeSlot(String time, String type, String weight) {
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
                Text(
                  type,
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  'Estimated: $weight',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
