import 'package:flutter/material.dart';

class BulkCollectionsPage extends StatefulWidget {
  const BulkCollectionsPage({super.key});

  @override
  State<BulkCollectionsPage> createState() => _BulkCollectionsPageState();
}

class _BulkCollectionsPageState extends State<BulkCollectionsPage> {
  final List<Map<String, dynamic>> _bulkCollections = [
    {
      'id': '1',
      'location': '123 Main Street',
      'time': '9:00 AM',
      'type': 'Construction Waste',
      'status': 'Pending',
      'weight': '2.5 tons'
    },
    {
      'id': '2',
      'location': '456 Oak Avenue',
      'time': '11:30 AM',
      'type': 'Industrial Waste',
      'status': 'Pending',
      'weight': '1.8 tons'
    },
    {
      'id': '3',
      'location': '789 Pine Road',
      'time': '2:00 PM',
      'type': 'Commercial Waste',
      'status': 'Pending',
      'weight': '3.0 tons'
    },
  ];

  void _markAsCompleted(String id) {
    setState(() {
      final index = _bulkCollections.indexWhere((item) => item['id'] == id);
      if (index != -1) {
        _bulkCollections[index]['status'] = 'Completed';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bulk Collections'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Today\'s Bulk Collections',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            ..._bulkCollections.map((collection) => _buildBulkCollectionItem(
                  collection['id'],
                  collection['location'],
                  collection['time'],
                  collection['type'],
                  collection['status'],
                  collection['weight'],
                )),
          ],
        ),
      ),
    );
  }

  Widget _buildBulkCollectionItem(
    String id,
    String location,
    String time,
    String type,
    String status,
    String weight,
  ) {
    final bool isCompleted = status == 'Completed';
    final Color statusColor = isCompleted ? Colors.green : Colors.orange;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        location,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Time: $time',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    status,
                    style: TextStyle(
                      color: statusColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Icon(Icons.delete_outline, size: 16, color: Colors.grey[600]),
                const SizedBox(width: 4),
                Text(
                  type,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14,
                  ),
                ),
                const SizedBox(width: 16),
                Icon(Icons.scale, size: 16, color: Colors.grey[600]),
                const SizedBox(width: 4),
                Text(
                  weight,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14,
                  ),
                ),
              ],
            ),
            if (!isCompleted) ...[
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => _markAsCompleted(id),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Mark as Completed'),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
