import 'package:flutter/material.dart';
import 'home.dart';

class ManageAccountPage extends StatelessWidget {
  const ManageAccountPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Contact Info'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const CircleAvatar(
              radius: 70,
              backgroundImage: NetworkImage(
                  'https://via.placeholder.com/150'), // Replace with your image
            ),
            const SizedBox(height: 24),
            _buildInfoRow('Name', 'Warren Buffet', false),
            const Divider(thickness: 1.5),
            _buildInfoRow('Birthdate', '05 November 1993', false),
            const Divider(thickness: 1.5),
            _buildInfoRow('Gender', 'Male', false),
            const Divider(thickness: 1.5),
            _buildInfoRow('Email', 'warren.buff@invest.ai', false),
            const Divider(thickness: 1.5),
            _buildInfoRow('Phone Number', '0557725781', true),
            const Divider(thickness: 1.5),
            _buildInfoRow('Address', 'greater accra', false),
            const Divider(thickness: 1.5),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String title, String value, bool isEditable) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          if (isEditable)
            TextButton(
              onPressed: () {
                // Handle change action
              },
              child: const Text(
                'Change',
                style: TextStyle(
                  color: Colors.blue,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

void main() => runApp(MaterialApp(
      home: const HomePage(),
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
    ));
