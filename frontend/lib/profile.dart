import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            // Add back navigation functionality here
          },
        ),
        title: const Text('Contact info'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 20),
            const CircleAvatar(
              radius: 50,
              backgroundImage: NetworkImage(
                  'https://example.com/profile.jpg'), // Replace with your image URL
            ),
            const SizedBox(height: 20),
            _buildInfoField(
              context,
              label: 'Name',
              value: 'Warren Buffet',
              onChange: () {
                // Add change functionality here
              },
            ),
            _buildInfoField(
              context,
              label: 'Birthdate',
              value: '05 November 1993',
              onChange: () {
                // Add change functionality here
              },
            ),
            _buildInfoField(
              context,
              label: 'Gender',
              value: 'Male',
              onChange: () {
                // Add change functionality here
              },
            ),
            _buildInfoField(
              context,
              label: 'Email',
              value: 'warren.buff@invest.ai',
            ),
            _buildInfoField(
              context,
              label: 'Phone Number',
              value: '-',
            ),
            _buildInfoField(
              context,
              label: 'Address',
              value: '-',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoField(BuildContext context,
      {required String label, required String value, Function()? onChange}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            if (onChange != null)
              TextButton(
                onPressed: onChange,
                child: const Text(
                  'Change',
                  style: TextStyle(
                    color: Colors.blue,
                    fontSize: 16,
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            color: Colors.black,
          ),
        ),
        const Divider(),
      ],
    );
  }
}
