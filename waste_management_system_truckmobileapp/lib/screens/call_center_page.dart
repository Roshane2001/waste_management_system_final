//imported packeges
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

// CallCenterPage class
class CallCenterPage extends StatelessWidget {
  const CallCenterPage({super.key});
  
  // Function for phone call
  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(scheme: 'tel', path: phoneNumber);
    try {
      await launchUrl(launchUri);
    } catch (e) {
      debugPrint('Could not launch $launchUri: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Call Center'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Contact Support',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            const Text(
              'If you need assistance with collections, routes, or any other issues, please contact our support center:',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 32),

            // Emergency contact
            _buildContactCard(
              title: 'Emergency Support',
              phoneNumber: '1-800-555-0123',
              description: 'For urgent issues requiring immediate attention',
              iconData: Icons.emergency,
              color: Colors.red,
              onTap: () => _makePhoneCall('18005550123'),
            ),
            const SizedBox(height: 16),

            // Technical support
            _buildContactCard(
              title: 'Technical Support',
              phoneNumber: '1-800-555-0124',
              description: 'For app or equipment related problems',
              iconData: Icons.support_agent,
              color: Colors.blue,
              onTap: () => _makePhoneCall('18005550124'),
            ),
            const SizedBox(height: 16),

            // General inquiries
            _buildContactCard(
              title: 'General Inquiries',
              phoneNumber: '1-800-555-0125',
              description: 'For schedule changes or non-urgent matters',
              iconData: Icons.contact_phone,
              color: Colors.green,
              onTap: () => _makePhoneCall('18005550125'),
            ),

            const SizedBox(height: 32),
            const Text(
              'Operating Hours: Monday - Friday, 8:00 AM - 6:00 PM',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContactCard({
    required String title,
    required String phoneNumber,
    required String description,
    required IconData iconData,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 2,
      child: InkWell(
        onTap: onTap,
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
                child: Icon(iconData, color: color, size: 32),
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
                      phoneNumber,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: TextStyle(color: Colors.grey[600], fontSize: 14),
                    ),
                  ],
                ),
              ),
              // Call icon
              const Icon(Icons.phone_in_talk, color: Colors.green),
            ],
          ),
        ),
      ),
    );
  }
}
