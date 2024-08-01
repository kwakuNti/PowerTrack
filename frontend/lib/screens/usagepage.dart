import 'package:flutter/material.dart';
import 'package:frontend/models/Meter.dart'; // Update the import to reflect your actual path
import 'package:frontend/screens/settings.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:google_fonts/google_fonts.dart';

class UsagePage extends StatelessWidget {
  final Meter meter;
  final double usage;

  const UsagePage({super.key, required this.meter, required this.usage});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Usage for ${meter.meterName}',
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
                        'Daily Usage', usage / 365, Colors.blue, Icons.today),
                    const SizedBox(height: 20),
                    _buildUsageCard('Weekly Usage', usage / 52, Colors.green,
                        Icons.calendar_view_week),
                    const SizedBox(height: 20),
                    _buildUsageCard('Monthly Usage', usage / 12, Colors.orange,
                        Icons.calendar_today),
                    const SizedBox(height: 20),
                    _buildStatCard('Peak Usage Time', '6:00 PM - 9:00 PM',
                        Colors.purple, Icons.schedule),
                    const SizedBox(height: 20),
                    _buildStatCard(
                        'Average Daily Usage',
                        '${(usage / 365).toStringAsFixed(2)} kWh',
                        Colors.teal,
                        Icons.bolt),
                    const SizedBox(height: 20),
                    _buildStatCard(
                        'Total Consumption',
                        '${usage.toStringAsFixed(2)} kWh',
                        Colors.brown,
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
                    percent: percent / usage,
                    center: Text(
                      '${(percent / usage * 100).toStringAsFixed(1)}%',
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
    var paint = Paint()
      ..color = Colors.lightBlueAccent.withOpacity(0.2)
      ..style = PaintingStyle.fill;
    var path = Path()
      ..moveTo(0, size.height * 0.4)
      ..quadraticBezierTo(
          size.width / 2, size.height * 0.6, size.width, size.height * 0.4)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
