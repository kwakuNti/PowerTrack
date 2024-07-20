import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:google_fonts/google_fonts.dart';
import 'home.dart';

class ManageAccountPage extends StatefulWidget {
  const ManageAccountPage({super.key});

  @override
  _ManageAccountPageState createState() => _ManageAccountPageState();
}

class _ManageAccountPageState extends State<ManageAccountPage> {
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  void _onRefresh() async {
    // Simulate fetching new data
    await Future.delayed(const Duration(milliseconds: 1000));
    _refreshController.refreshCompleted();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Contact Info',
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SmartRefresher(
        controller: _refreshController,
        onRefresh: _onRefresh,
        child: Padding(
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
              _buildInfoRow('Address', 'Greater Accra', false),
              const Divider(thickness: 1.5),
            ],
          ),
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
                style: GoogleFonts.poppins(
                  color: Colors.grey,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: GoogleFonts.poppins(
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
              child: Text(
                'Change',
                style: GoogleFonts.poppins(
                  color: Colors.blue,
                ),
              ),
            ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _refreshController.dispose();
    super.dispose();
  }
}
