import 'package:flutter/material.dart';

import 'home.dart';
import 'signup.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 20),
            const Text(
              'Login',
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
              'Let’s get started!',
              style: TextStyle(
                fontSize: 16,
                color: Colors.black,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),
            const Spacer(), // This will push the widgets to the bottom
            Align(
              alignment: Alignment.bottomCenter,
              child: Column(
                children: [
                  TextField(
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 20, horizontal: 16),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: const BorderSide(
                            color: Color(0xFF828282), width: 0.5),
                      ),
                      labelText: 'Email address',
                      labelStyle: const TextStyle(
                        fontSize: 17,
                        fontFamily: 'Adamina',
                        fontWeight: FontWeight.normal,
                        color: Color(0xFF828282),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    obscureText: true,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 20, horizontal: 16),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: const BorderSide(
                            color: Color(0xFF828282), width: 0.5),
                      ),
                      labelText: 'Password',
                      labelStyle: const TextStyle(
                        fontSize: 17,
                        fontFamily: 'Adamina',
                        fontWeight: FontWeight.normal,
                        color: Color(0xFF828282),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  SizedBox(
                    width: 343,
                    height: 60,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const HomePage()),
                        ); // Add login functionality here
                      },
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
                      child: const Text('Login',
                          style: TextStyle(color: Colors.white)),
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const SignUpPage()),
                      ); // Add login functionality here
                    },
                    child: const Text(
                      'Don’t have an account?',
                      style: TextStyle(fontSize: 16, color: Colors.blue),
                    ),
                  ),
                  const SizedBox(height: 20), // Add some space at the bottom
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
