import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class WasteDetailsScreen extends StatefulWidget {
  const WasteDetailsScreen({super.key});

  @override
  State<WasteDetailsScreen> createState() => _WasteDetailsScreenState();
}

class _WasteDetailsScreenState extends State<WasteDetailsScreen> {
  // Mock data for resident's waste collection history
  final List<Map<String, dynamic>> _collectionHistory = [
    {
      'date': '2024-03-15',
      'type': 'General Waste',
      'weight': '2.5 kg',
      'status': 'Collected',
    },
    {
      'date': '2024-03-14',
      'type': 'Recyclables',
      'weight': '1.8 kg',
      'status': 'Collected',
    },
    {
      'date': '2024-03-13',
      'type': 'Organic Waste',
      'weight': '1.2 kg',
      'status': 'Collected',
    },
    {
      'date': '2024-03-12',
      'type': 'General Waste',
      'weight': '2.1 kg',
      'status': 'Collected',
    },
  ];

  // Mock data for waste type distribution
  final Map<String, double> _wasteTypeDistribution = {
    'General Waste': 45,
    'Recyclables': 30,
    'Organic Waste': 25,
  };

  // Mock data for monthly waste collection
  final List<Map<String, dynamic>> _monthlyData = [
    {'month': 'Jan', 'weight': 8.5},
    {'month': 'Feb', 'weight': 7.2},
    {'month': 'Mar', 'weight': 9.1},
    {'month': 'Apr', 'weight': 8.8},
    {'month': 'May', 'weight': 7.5},
    {'month': 'Jun', 'weight': 8.2},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Waste Details'),
        backgroundColor: Colors.green,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Resident Info Card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Resident Information',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildInfoRow('Name', 'John Doe'),
                    _buildInfoRow('Resident ID', 'RES123456'),
                    _buildInfoRow('Address', '123 Green Street, Colombo'),
                    _buildInfoRow('Collection Day', 'Monday & Thursday'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Waste Type Distribution Chart
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Waste Type Distribution',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      height: 200,
                      child: BarChart(
                        BarChartData(
                          alignment: BarChartAlignment.spaceAround,
                          maxY: 50,
                          barTouchData: BarTouchData(enabled: false),
                          titlesData: FlTitlesData(
                            show: true,
                            bottomTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                getTitlesWidget: (value, meta) {
                                  switch (value.toInt()) {
                                    case 0:
                                      return const Text('General');
                                    case 1:
                                      return const Text('Recyclable');
                                    case 2:
                                      return const Text('Organic');
                                    default:
                                      return const Text('');
                                  }
                                },
                              ),
                            ),
                            leftTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                reservedSize: 40,
                                getTitlesWidget: (value, meta) {
                                  return Text('${value.toInt()}%');
                                },
                              ),
                            ),
                            topTitles: const AxisTitles(
                              sideTitles: SideTitles(showTitles: false),
                            ),
                            rightTitles: const AxisTitles(
                              sideTitles: SideTitles(showTitles: false),
                            ),
                          ),
                          gridData: const FlGridData(
                            show: true,
                            horizontalInterval: 10,
                            drawVerticalLine: false,
                          ),
                          borderData: FlBorderData(show: false),
                          barGroups: [
                            BarChartGroupData(
                              x: 0,
                              barRods: [
                                BarChartRodData(
                                  toY: _wasteTypeDistribution['General Waste']!,
                                  color: Colors.grey,
                                  width: 20,
                                  borderRadius: const BorderRadius.vertical(
                                    top: Radius.circular(4),
                                  ),
                                ),
                              ],
                            ),
                            BarChartGroupData(
                              x: 1,
                              barRods: [
                                BarChartRodData(
                                  toY: _wasteTypeDistribution['Recyclables']!,
                                  color: Colors.blue,
                                  width: 20,
                                  borderRadius: const BorderRadius.vertical(
                                    top: Radius.circular(4),
                                  ),
                                ),
                              ],
                            ),
                            BarChartGroupData(
                              x: 2,
                              barRods: [
                                BarChartRodData(
                                  toY: _wasteTypeDistribution['Organic Waste']!,
                                  color: Colors.green,
                                  width: 20,
                                  borderRadius: const BorderRadius.vertical(
                                    top: Radius.circular(4),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Monthly Waste Collection Trend
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Monthly Waste Collection Trend',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      height: 200,
                      child: LineChart(
                        LineChartData(
                          gridData: const FlGridData(
                            show: true,
                            drawVerticalLine: false,
                            horizontalInterval: 2,
                          ),
                          titlesData: FlTitlesData(
                            show: true,
                            bottomTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                getTitlesWidget: (value, meta) {
                                  if (value.toInt() >= 0 && value.toInt() < _monthlyData.length) {
                                    return Text(_monthlyData[value.toInt()]['month']);
                                  }
                                  return const Text('');
                                },
                              ),
                            ),
                            leftTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                reservedSize: 40,
                                getTitlesWidget: (value, meta) {
                                  return Text('${value.toInt()} kg');
                                },
                              ),
                            ),
                            topTitles: const AxisTitles(
                              sideTitles: SideTitles(showTitles: false),
                            ),
                            rightTitles: const AxisTitles(
                              sideTitles: SideTitles(showTitles: false),
                            ),
                          ),
                          borderData: FlBorderData(show: true),
                          minX: 0,
                          maxX: 5,
                          minY: 0,
                          maxY: 10,
                          lineBarsData: [
                            LineChartBarData(
                              spots: List.generate(
                                _monthlyData.length,
                                (index) => FlSpot(
                                  index.toDouble(),
                                  _monthlyData[index]['weight'],
                                ),
                              ),
                              isCurved: true,
                              color: Colors.green,
                              barWidth: 3,
                              isStrokeCapRound: true,
                              dotData: const FlDotData(show: true),
                              belowBarData: BarAreaData(
                                show: true,
                                color: Colors.green.withOpacity(0.2),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Collection History
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Recent Collection History',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _collectionHistory.length,
                      itemBuilder: (context, index) {
                        final collection = _collectionHistory[index];
                        return ListTile(
                          leading: const CircleAvatar(
                            backgroundColor: Colors.green,
                            child: Icon(
                              Icons.delete,
                              color: Colors.white,
                            ),
                          ),
                          title: Text(collection['type']),
                          subtitle: Text('Date: ${collection['date']}'),
                          trailing: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                collection['weight'],
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                collection['status'],
                                style: const TextStyle(
                                  color: Colors.green,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
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

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
          ),
          Expanded(
            child: Text(value),
          ),
        ],
      ),
    );
  }
}
