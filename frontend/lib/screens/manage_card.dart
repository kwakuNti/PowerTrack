import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:frontend/providers/auth_provider.dart';
import 'package:frontend/services/auth_services.dart';
import 'package:frontend/models/Meter.dart';

class ManageCardPage extends StatefulWidget {
  const ManageCardPage({super.key});

  @override
  State<ManageCardPage> createState() => _ManageCardPageState();
}

class _ManageCardPageState extends State<ManageCardPage> {
  List<Meter> meters = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchMeters();
  }

  Future<void> _fetchMeters() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final userId = authProvider.user?.user_id;

    if (userId == null) {
      print('User ID is not available');
      setState(() {
        _isLoading = false;
      });
      return;
    }

    try {
      final fetchedMeters = await AuthService().getMetersByUserId(userId);
      setState(() {
        meters = fetchedMeters;
        _isLoading = false;
      });
    } catch (e) {
      print('Error fetching meters: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> deleteMeter(int index) async {
    final meterId = meters[index].meterId;
    try {
      await AuthService().deleteMeter(meterId);
      setState(() {
        meters.removeAt(index);
      });
    } catch (e) {
      print('Error deleting meter: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Meters'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: meters.length,
              itemBuilder: (context, index) {
                final meter = meters[index];
                return MeterItem(
                  meterName: meter.meterName,
                  location: meter.location,
                  onDelete: () => deleteMeter(index),
                );
              },
            ),
    );
  }
}

class MeterItem extends StatelessWidget {
  final String meterName;
  final String location;
  final VoidCallback onDelete;

  const MeterItem({
    required this.meterName,
    required this.location,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
      elevation: 5,
      child: ListTile(
        contentPadding: const EdgeInsets.all(15.0),
        title: Text(
          meterName,
          style: const TextStyle(
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(location),
        trailing: IconButton(
          icon: const Icon(Icons.delete, color: Colors.red),
          onPressed: onDelete,
        ),
      ),
    );
  }
}
