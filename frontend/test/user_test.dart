// import 'package:flutter/material.dart';
// import 'package:flutter_spinkit/flutter_spinkit.dart';
// import 'package:frontend/providers/auth_provider.dart';
// import 'package:local_auth/local_auth.dart';
// import 'package:provider/provider.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'login_screen.dart'; // Import the login screen
// import 'home.dart';

// class SplashScreen extends StatefulWidget {
//   const SplashScreen({super.key});

//   @override
//   State<SplashScreen> createState() => _SplashScreenState();
// }

// class _SplashScreenState extends State<SplashScreen> {
//   final LocalAuthentication auth = LocalAuthentication();

//   @override
//   void initState() {
//     super.initState();
//     _checkLoginStatus();
//   }

//   Future<void> _checkLoginStatus() async {
//     final prefs = await SharedPreferences.getInstance();
//     final email = prefs.getString('email');
//     final password = prefs.getString('password');
//     final biometricEnabled = prefs.getBool('biometricEnabled') ?? false;

//     print('Stored email: $email');
//     print('Stored password: $password');
//     print('Biometric enabled: $biometricEnabled');

//     if (email != null && password != null) {
//       if (biometricEnabled) {
//         print('Attempting biometric authentication...');
//         bool authenticated = await _authenticateWithBiometrics();
//         if (authenticated) {
//           print('Biometric authentication successful');
//           _login(email, password);
//         } else {
//           print('Biometric authentication failed');
//           _navigateToLogin();
//         }
//       } else {
//         print('Logging in with stored credentials...');
//         _login(email, password);
//       }
//     } else {
//       print('No stored credentials found');
//       _navigateToWelcome();
//     }
//   }

//   Future<bool> _authenticateWithBiometrics() async {
//     try {
//       return await auth.authenticate(
//         localizedReason: 'Please authenticate to continue',
//         options: const AuthenticationOptions(
//           useErrorDialogs: true,
//           stickyAuth: true,
//         ),
//       );
//     } catch (e) {
//       print('Error during biometric authentication: $e');
//       return false;
//     }
//   }

//   void _login(String email, String password) async {
//     final authProvider = Provider.of<AuthProvider>(context, listen: false);
//     print('Attempting to log in user with email: $email');
//     await authProvider.login(email, password);
//     if (authProvider.loginSuccess == true) {
//       print('Login successful');
//       if (!mounted) return; // Check if the widget is still in the widget tree
//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(builder: (context) => const HomePage()),
//       );
//     } else {
//       print('Login failed: ${authProvider.errorMessage}');
//       _navigateToLogin();
//     }
//   }

//   void _navigateToLogin() {
//     print('Navigating to LoginScreen');
//     if (!mounted) return;
//     Navigator.pushReplacement(
//       context,
//       MaterialPageRoute(builder: (context) => const LoginScreen()),
//     );
//   }

//   void _navigateToWelcome() {
//     print('Navigating to WelcomeScreen');
//     if (!mounted) return;
//     Navigator.pushReplacement(
//       context,
//       MaterialPageRoute(builder: (context) => const LoginScreen()),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Container(
//         decoration: const BoxDecoration(
//           gradient: LinearGradient(
//             colors: [
//               Color(0xFF2196F3), // Blue color
//               Colors.white,
//             ],
//             begin: Alignment.topCenter,
//             end: Alignment.bottomCenter,
//           ),
//         ),
//         child: Center(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: <Widget>[
//               const Text(
//                 'PowerTrack',
//                 style: TextStyle(
//                   fontSize: 32,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.white,
//                 ),
//               ),
//               const SizedBox(height: 8),
//               const Text(
//                 'Manage your electric prepaid',
//                 style: TextStyle(
//                   fontSize: 16,
//                   color: Colors.white,
//                 ),
//               ),
//               const SizedBox(height: 24),
//               Image.asset(
//                 'assets/splash.png', // Add your image asset here
//                 width: 228,
//                 height: 228,
//               ),
//               const SizedBox(height: 150),
//               const SpinKitFadingCircle(
//                 color: Colors.blue,
//                 size: 50.0,
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
