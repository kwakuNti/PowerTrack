import 'package:flutter/material.dart';
import 'package:frontend/providers/auth_provider.dart';
import 'package:frontend/services/otp.dart';
import 'package:provider/provider.dart';
import 'signup.dart';
import 'home.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class OTPVerificationPage extends StatefulWidget {
  const OTPVerificationPage({super.key});

  @override
  State<OTPVerificationPage> createState() => _OTPVerificationPageState();
}

class _OTPVerificationPageState extends State<OTPVerificationPage> {
  final List<TextEditingController> _otpControllers =
      List.generate(6, (index) => TextEditingController());
  bool _isLoading = false;

  @override
  void dispose() {
    for (var controller in _otpControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _verifyOTP() async {
    setState(() {
      _isLoading = true;
    });

    String otp = _otpControllers.map((controller) => controller.text).join();
    bool isValidOTP = await OTPService.verifyOTP(otp);

    if (isValidOTP) {
      await _registerAndLogin();
    } else {
      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Invalid OTP. Please try again.')),
      );
    }

    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _registerAndLogin() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final email = authProvider.registrationDetails['email'];
    final first_name = authProvider.registrationDetails['first_name'];
    final last_name = authProvider.registrationDetails['last_name'];
    final password = authProvider.registrationDetails['password'];
    final confirmPassword =
        authProvider.registrationDetails['confirm_password'];

    print('Attempting registration with email: $email');
    print(
        'Registration details - first_name: $first_name, last_name: $last_name, password: $password, confirm_password: $confirmPassword');

    if (email != null &&
        password != null &&
        first_name != null &&
        last_name != null) {
      final response = await http.post(
        Uri.parse('http://localhost/PowerTrack/backend/users'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'password': password,
          'confirm_password': confirmPassword,
          'first_name': first_name,
          'last_name': last_name,
        }),
      );

      print('Registration response status: ${response.statusCode}');
      print('Registration response body: ${response.body}');

      if (response.statusCode == 200) {
        final responseBody = jsonDecode(response.body);
        if (responseBody['success']) {
          // Registration successful, login the user
          await authProvider.login(email, password);
          if (authProvider.user != null) {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const HomePage()),
              (route) => false,
            );
          } else {
            print('Login failed!');
          }
        } else {
          print('Registration failed!');
        }
      } else {
        print('Registration request failed!');
      }
    } else {
      print('Required registration details are missing!');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const SignUpPage()),
            );
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 20),
              const Text(
                'Verify OTP',
                style: TextStyle(
                  fontSize: 34.0,
                  fontFamily: 'DMSans',
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              const Text(
                'Enter the 6-digit code sent to your email',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(6, (index) {
                  return _otpTextField(context, index);
                }),
              ),
              const SizedBox(height: 30),
              SizedBox(
                width: 343,
                height: 60,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _verifyOTP,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4169E1),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    textStyle: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.normal,
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 20),
                  ),
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text('Verify',
                          style: TextStyle(color: Colors.white)),
                ),
              ),
              const SizedBox(height: 20),
              TextButton(
                onPressed: _isLoading
                    ? null
                    : () {
                        // Add functionality to resend OTP here
                      },
                child: const Text(
                  'Didn’t receive the code?',
                  style: TextStyle(fontSize: 16, color: Colors.blue),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _otpTextField(BuildContext context, int index) {
    return SizedBox(
      width: 50,
      child: TextField(
        controller: _otpControllers[index],
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        maxLength: 1,
        decoration: InputDecoration(
          counterText: '',
          contentPadding: const EdgeInsets.symmetric(vertical: 20),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Color(0xFF828282), width: 0.5),
          ),
        ),
      ),
    );
  }
}
