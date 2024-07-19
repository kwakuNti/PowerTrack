import 'package:flutter/material.dart';
import 'package:frontend/models/meter_details.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class UsagePage extends StatelessWidget {
  final MeterDetails meterDetails;

  const UsagePage({super.key, required this.meterDetails});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Usage for ${meterDetails.meterName}'),
        backgroundColor: Colors.teal,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildUsageCard('Daily Usage', 0.7, Colors.blue, Icons.today),
              const SizedBox(height: 20),
              _buildUsageCard(
                  'Weekly Usage', 0.5, Colors.green, Icons.calendar_view_week),
              const SizedBox(height: 20),
              _buildUsageCard(
                  'Monthly Usage', 0.3, Colors.orange, Icons.calendar_today),
              // Add more cards as needed
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUsageCard(
      String title, double percent, Color color, IconData icon) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Icon(icon, size: 40, color: color),
            const SizedBox(width: 16.0),
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
                  const SizedBox(height: 10),
                  LinearPercentIndicator(
                    lineHeight: 14.0,
                    animation: true,
                    percent: percent,
                    center: Text(
                      '${(percent * 100).toStringAsFixed(1)}%',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 12.0,
                        color: Colors.white,
                      ),
                    ),
                    linearStrokeCap: LinearStrokeCap.roundAll,
                    progressColor: color,
                    backgroundColor: color.withOpacity(0.2),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
