import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

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
        title: const Text('Settings'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {
              // Add notification functionality here
            },
          ),
        ],
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
            const Divider(),
            _buildSettingsOption(
              context,
              icon: Icons.credit_card,
              text: 'Manage Cards',
              onTap: () {
                // Add manage cards functionality here
              },
            ),
            _buildSettingsOption(
              context,
              icon: Icons.notifications,
              text: 'Manage Notification',
              onTap: () {
                // Add manage notification functionality here
              },
            ),
            _buildSettingsOption(
              context,
              icon: Icons.account_circle,
              text: 'Manage Account',
              onTap: () {
                // Add manage account functionality here
              },
            ),
            _buildSettingsOption(
              context,
              icon: Icons.delete,
              text: 'Delete Account',
              onTap: () {
                // Add delete account functionality here
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: '',
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsOption(BuildContext context,
      {required IconData icon, required String text, required Function() onTap}) {
    return ListTile(
      leading: Icon(icon, color: Colors.blue),
      title: Text(text),
      onTap: onTap,
    );
  }
}
