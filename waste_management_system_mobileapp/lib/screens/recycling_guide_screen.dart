import 'package:flutter/material.dart';

class RecyclingGuideScreen extends StatelessWidget {
  const RecyclingGuideScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Recycling Guide'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Introduction Card
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.recycling,
                          color: Colors.green,
                          size: 28,
                        ),
                        SizedBox(width: 8),
                        Text(
                          'Why Recycle?',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Recycling helps conserve natural resources, reduce landfill waste, and protect our environment. By properly sorting your waste, you contribute to a sustainable future for our community.',
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Recycling Categories
            const Text(
              'Recycling Categories',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
            const SizedBox(height: 16),
            _buildRecyclingCategory(
              'Paper & Cardboard',
              'Newspapers, magazines, cardboard boxes, paper bags, office paper',
              Icons.description,
              Colors.blue,
              [
                'Clean and dry paper only',
                'Remove plastic windows from envelopes',
                'Flatten cardboard boxes',
                'No greasy pizza boxes',
              ],
            ),
            const SizedBox(height: 16),
            _buildRecyclingCategory(
              'Plastics',
              'Bottles, containers, jugs, tubs, lids (check for recycling symbol)',
              Icons.local_drink,
              Colors.orange,
              [
                'Rinse containers before recycling',
                'Remove caps from bottles',
                'No plastic bags or film',
                'No Styrofoam or foam packaging',
              ],
            ),
            const SizedBox(height: 16),
            _buildRecyclingCategory(
              'Glass',
              'Bottles, jars, containers (all colors)',
              Icons.wine_bar,
              Colors.purple,
              [
                'Rinse thoroughly before recycling',
                'Remove caps and lids',
                'No broken glass in recycling bin',
                'No mirrors or window glass',
              ],
            ),
            const SizedBox(height: 16),
            _buildRecyclingCategory(
              'Metal',
              'Aluminum cans, steel cans, tin cans, metal lids',
              Icons.circle,
              Colors.grey,
              [
                'Rinse cans before recycling',
                'Remove paper labels if possible',
                'Flatten aluminum cans to save space',
                'No aerosol cans with remaining contents',
              ],
            ),
            const SizedBox(height: 24),

            // Recycling Tips
            const Text(
              'Recycling Tips',
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
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    _buildTipItem(
                      'Clean your recyclables',
                      'Rinse containers to remove food residue before recycling.',
                      Icons.cleaning_services,
                    ),
                    const Divider(),
                    _buildTipItem(
                      'Check local guidelines',
                      'Recycling rules vary by location. Follow your local guidelines.',
                      Icons.location_on,
                    ),
                    const Divider(),
                    _buildTipItem(
                      'Avoid wishcycling',
                      'Don\'t put items in recycling that you\'re unsure about. When in doubt, throw it out.',
                      Icons.help_outline,
                    ),
                    const Divider(),
                    _buildTipItem(
                      'Keep it loose',
                      'Don\'t bag your recyclables. They should be loose in the bin.',
                      Icons.open_in_new,
                    ),
                    const Divider(),
                    _buildTipItem(
                      'Reduce and reuse first',
                      'Recycling is important, but reducing waste and reusing items is even better.',
                      Icons.reduce_capacity,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Common Mistakes
            const Text(
              'Common Recycling Mistakes',
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
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    _buildMistakeItem(
                      'Plastic bags in recycling bin',
                      'Plastic bags should be returned to grocery stores for recycling.',
                      Icons.error_outline,
                      Colors.red,
                    ),
                    const Divider(),
                    _buildMistakeItem(
                      'Food-contaminated items',
                      'Pizza boxes with grease or food containers with residue should go in the trash.',
                      Icons.error_outline,
                      Colors.red,
                    ),
                    const Divider(),
                    _buildMistakeItem(
                      'Small items',
                      'Items smaller than a credit card can\'t be processed and should go in the trash.',
                      Icons.error_outline,
                      Colors.red,
                    ),
                    const Divider(),
                    _buildMistakeItem(
                      'Tanglers',
                      'Hoses, wires, and chains can damage recycling equipment.',
                      Icons.error_outline,
                      Colors.red,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Recycling Schedule
            const Text(
              'Recycling Collection Schedule',
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
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    _buildScheduleItem(
                      'Curbside Collection',
                      'Every Wednesday, 8:00 AM - 5:00 PM',
                      Icons.calendar_today,
                      Colors.green,
                    ),
                    const Divider(),
                    _buildScheduleItem(
                      'Recycling Center Drop-off',
                      'Monday-Saturday, 9:00 AM - 4:00 PM',
                      Icons.location_on,
                      Colors.green,
                    ),
                    const Divider(),
                    _buildScheduleItem(
                      'Special Collection Events',
                      'First Saturday of each month',
                      Icons.event,
                      Colors.green,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Contact Information
            const Text(
              'Need Help?',
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
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    ListTile(
                      leading: const Icon(Icons.phone, color: Colors.green),
                      title: const Text('Recycling Hotline'),
                      subtitle: const Text('(555) 123-4567'),
                      trailing: IconButton(
                        icon: const Icon(Icons.call),
                        onPressed: () {
                          // TODO: Implement call functionality
                        },
                      ),
                    ),
                    const Divider(),
                    ListTile(
                      leading: const Icon(Icons.email, color: Colors.green),
                      title: const Text('Email Support'),
                      subtitle: const Text('recycling@citywaste.com'),
                      trailing: IconButton(
                        icon: const Icon(Icons.email),
                        onPressed: () {
                          // TODO: Implement email functionality
                        },
                      ),
                    ),
                    const Divider(),
                    ListTile(
                      leading: const Icon(Icons.help, color: Colors.green),
                      title: const Text('FAQs'),
                      subtitle: const Text('Common recycling questions'),
                      trailing: IconButton(
                        icon: const Icon(Icons.arrow_forward),
                        onPressed: () {
                          // TODO: Navigate to FAQs
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildRecyclingCategory(
    String title,
    String description,
    IconData icon,
    Color color,
    List<String> items,
  ) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  icon,
                  color: color,
                  size: 24,
                ),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              description,
              style: const TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 16),
            const Text(
              'Guidelines:',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            ...items.map((item) => Padding(
                  padding: const EdgeInsets.only(bottom: 4.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(
                        Icons.check_circle,
                        size: 16,
                        color: Colors.green,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          item,
                          style: const TextStyle(fontSize: 14),
                        ),
                      ),
                    ],
                  ),
                )),
          ],
        ),
      ),
    );
  }

  Widget _buildTipItem(String title, String description, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            color: Colors.green,
            size: 24,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: const TextStyle(fontSize: 14),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMistakeItem(
    String title,
    String description,
    IconData icon,
    Color color,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            color: color,
            size: 24,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: const TextStyle(fontSize: 14),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScheduleItem(
    String title,
    String description,
    IconData icon,
    Color color,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(
            icon,
            color: color,
            size: 24,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: const TextStyle(fontSize: 14),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
