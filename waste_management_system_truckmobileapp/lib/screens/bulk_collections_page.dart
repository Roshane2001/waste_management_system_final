//imported packages
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:waste_management_system_truckmobileapp/providers/user_provider.dart';
import 'package:waste_management_system_truckmobileapp/providers/waste_provider.dart';
import 'package:waste_management_system_truckmobileapp/models/waste_pickup_model.dart';
import 'package:intl/intl.dart';

//bulk waste collections requests for the truck
class BulkCollectionsPage extends StatefulWidget {
  const BulkCollectionsPage({super.key});

  @override
  State<BulkCollectionsPage> createState() => _BulkCollectionsPageState();
}

class _BulkCollectionsPageState extends State<BulkCollectionsPage> {
  //bulk waste collections requests for the truck
  Future<void> _fetchBulkPickups() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    await context.read<WasteProvider>().fetchBulkPickups(
      userProvider.user!.userId,
    );
  }

  @override
  void initState() {
    _fetchBulkPickups();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //get bulk pickups and loading from provider
    final bulkPickups = context.read<WasteProvider>().bulkPickups;
    final isLoading = context.watch<WasteProvider>().isLoading;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Bulk Collections'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      body:
          isLoading
              ? const Center(
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
                    const Text(
                      'Bulk Collections',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Display bulk pickups
                    bulkPickups.isEmpty
                        ? const Center(
                          child: Text('No bulk collections available'),
                        )
                        : ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: bulkPickups.length,
                          itemBuilder: (context, index) {
                            final pickup = bulkPickups[index];
                            return _buildBulkCollectionItem(pickup);
                          },
                        ),
                  ],
                ),
              ),
    );
  }
  
  //widget for bulk collection item
  Widget _buildBulkCollectionItem(WastePickupModel pickup) {
    // Format timestamp to display time
    final time = DateFormat('h:mm a').format(pickup.date.toDate());

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
                        pickup.address,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Time: $time',
                        style: TextStyle(color: Colors.grey[600], fontSize: 14),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'User: ${pickup.userName}',
                        style: TextStyle(color: Colors.grey[600], fontSize: 14),
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
                    color: Colors.orangeAccent.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    "Pending",
                    style: TextStyle(
                      color: Colors.orangeAccent,
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
                  "123",
                  style: TextStyle(color: Colors.grey[600], fontSize: 14),
                ),
                const SizedBox(width: 16),
                Icon(Icons.scale, size: 16, color: Colors.grey[600]),
                const SizedBox(width: 4),
                Text(
                  "123",
                  style: TextStyle(color: Colors.grey[600], fontSize: 14),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              'Title: ${pickup.title}',
              style: TextStyle(color: Colors.grey[600], fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}
