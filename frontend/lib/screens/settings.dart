import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/meter_details.dart'; // Import the model
import 'feedback.dart';
import 'manage_card.dart';
import 'profile.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _biometricsEnabled = false;
  final LocalAuthentication auth = LocalAuthentication();
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _biometricsEnabled = prefs.getBool('biometricEnabled') ?? false;
    });
  }

  Future<void> _updateBiometricEnabled(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('biometricEnabled', value);
    setState(() {
      _biometricsEnabled = value;
    });
  }

  Future<void> _authenticateWithBiometrics() async {
    try {
      final bool canCheckBiometrics = await auth.canCheckBiometrics;
      final List<BiometricType> availableBiometrics =
          await auth.getAvailableBiometrics();

      if (canCheckBiometrics && availableBiometrics.isNotEmpty) {
        final bool authenticated = await auth.authenticate(
          localizedReason: 'Please authenticate to enable biometrics',
          options: const AuthenticationOptions(
            useErrorDialogs: true,
            stickyAuth: true,
          ),
        );
        if (authenticated) {
          _updateBiometricEnabled(true);
        } else {
          setState(() {
            _biometricsEnabled = false;
          });
        }
      } else {
        _showBiometricSetupDialog();
        setState(() {
          _biometricsEnabled = false;
        });
      }
    } catch (e) {
      print(e);
      setState(() {
        _biometricsEnabled = false;
      });
    }
  }

  void _showBiometricSetupDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Biometrics Not Set Up'),
          content: const Text(
              'Biometric authentication is not set up on this device. Please set it up in your device settings.'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _onRefresh() async {
    await Future.delayed(const Duration(milliseconds: 1000));
    _refreshController.refreshCompleted();
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Logout'),
          content: const Text('Are you sure you want to log out?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                // Add your logout logic here
              },
              child: const Text('Logout'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SmartRefresher(
        controller: _refreshController,
        onRefresh: _onRefresh,
        child: Stack(
          children: [
            CustomPaint(
              size: Size(MediaQuery.of(context).size.width,
                  MediaQuery.of(context).size.height),
              painter: BackgroundPainter(),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListView(
                children: [
                  const Center(
                    child: CircleAvatar(
                      radius: 80,
                      backgroundImage: AssetImage(
                          'assets/profile_picture.png'), // Update this with your image path
                    ),
                  ),
                  const SizedBox(height: 20),
                  ListTile(
                    leading: const Icon(Icons.credit_card),
                    title: Text(
                      'Manage Cards',
                      style: GoogleFonts.poppins(),
                    ),
                    trailing: const Icon(Icons.arrow_forward_ios),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const ManageCardPage()),
                      );
                    },
                  ),
                  const Divider(),
                  ListTile(
                    leading: const Icon(Icons.person),
                    title: Text(
                      'Manage Account',
                      style: GoogleFonts.poppins(),
                    ),
                    trailing: const Icon(Icons.arrow_forward_ios),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const ManageAccountPage()),
                      );
                    },
                  ),
                  const Divider(),
                  ListTile(
                    leading: const Icon(Icons.lock),
                    title: Text(
                      'Enable Biometrics',
                      style: GoogleFonts.poppins(),
                    ),
                    trailing: Switch(
                      value: _biometricsEnabled,
                      onChanged: (bool value) {
                        if (value) {
                          _authenticateWithBiometrics();
                        } else {
                          _updateBiometricEnabled(value);
                        }
                      },
                    ),
                  ),
                  const Divider(),
                  ListTile(
                    leading: const Icon(Icons.logout),
                    title: Text(
                      'Logout',
                      style: GoogleFonts.poppins(),
                    ),
                    onTap: _showLogoutDialog,
                  ),
                  const Divider(),
                  ListTile(
                    leading: const Icon(Icons.error),
                    title: Text(
                      'Report Issue',
                      style: GoogleFonts.poppins(),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const FeedbackPage()),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _refreshController.dispose();
    super.dispose();
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
