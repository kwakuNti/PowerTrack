import 'package:flutter/material.dart';
import 'package:frontend/models/meter_details.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:google_fonts/google_fonts.dart';

class UsagePage extends StatelessWidget {
  final MeterDetails meterDetails;

  const UsagePage({super.key, required this.meterDetails});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Usage for ${meterDetails.meterName}',
          style: GoogleFonts.poppins(),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          // Handle refresh logic here
        },
        child: Stack(
          children: [
            CustomPaint(
              size: Size(MediaQuery.of(context).size.width,
                  MediaQuery.of(context).size.height),
              painter: BackgroundPainter(),
            ),
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildUsageCard(
                        'Daily Usage', 0.7, Colors.blue, Icons.today),
                    const SizedBox(height: 20),
                    _buildUsageCard('Weekly Usage', 0.5, Colors.green,
                        Icons.calendar_view_week),
                    const SizedBox(height: 20),
                    _buildUsageCard('Monthly Usage', 0.3, Colors.orange,
                        Icons.calendar_today),
                    const SizedBox(height: 20),
                    _buildUsageCard(
                        'Annual Usage', 0.1, Colors.red, Icons.timelapse),
                    const SizedBox(height: 20),
                    _buildStatCard('Peak Usage Time', '6:00 PM - 9:00 PM',
                        Colors.purple, Icons.schedule),
                    const SizedBox(height: 20),
                    _buildStatCard('Average Daily Usage', '25 kWh', Colors.teal,
                        Icons.bolt),
                    const SizedBox(height: 20),
                    _buildStatCard('Total Consumption', '900 kWh', Colors.brown,
                        Icons.power),
                  ],
                ),
              ),
            ),
          ],
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
                    style: GoogleFonts.poppins(
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

  Widget _buildStatCard(
      String title, String value, Color color, IconData icon) {
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
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    value,
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                    ),
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

class BackgroundPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.blue.shade50;
    final rect = Rect.fromLTWH(0, 0, size.width, size.height);
    canvas.drawRect(rect, paint);

    paint.color = Colors.blue.shade100;
    canvas.drawCircle(
        Offset(size.width * 0.25, size.height * 0.25), 150, paint);
    canvas.drawCircle(
        Offset(size.width * 0.75, size.height * 0.75), 200, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
