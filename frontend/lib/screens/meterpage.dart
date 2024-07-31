// lib/screens/meterpage.dart

import 'package:flutter/material.dart';
import 'package:frontend/providers/auth_provider.dart';
import 'package:frontend/services/auth_services.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'enter_meter.dart';
import '/models/Meter.dart';
import 'payment.dart';
import 'usagepage.dart'; // Import the UsagePage

class MetersPage extends StatefulWidget {
  const MetersPage({super.key});

  @override
  State<MetersPage> createState() => _MetersPageState();
}

class _MetersPageState extends State<MetersPage> {
  final List<Meter> _meters = [];
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  final AuthService _authService = AuthService(); // Initialize AuthService
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchMeters();
  }

  Future<void> _fetchMeters() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final userId =
          Provider.of<AuthProvider>(context, listen: false).user?.user_id;
      if (userId == null) {
        setState(() {
          _errorMessage = 'User ID is null';
        });
        print('User ID is null');
        return;
      }

      final meters = await _authService.getMetersByUserId(userId);
      setState(() {
        _meters.clear();
        _meters.addAll(meters);
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'An error occurred: $e';
      });
      print('Error during meter fetch: $e');
    } finally {
      setState(() {
        _isLoading = false;
        _refreshController.refreshCompleted();
      });
    }
  }

  void _addMeter(Meter meter) {
    setState(() {
      _meters.add(meter);
    });
  }

  void _onRefresh() async {
    await _fetchMeters();
    _refreshController.refreshCompleted();
  }

  @override
  void dispose() {
    _refreshController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SmartRefresher(
        controller: _refreshController,
        onRefresh: _onRefresh,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _buildAddMeterCard(context),
                    ..._meters.map((meter) => _buildMeterCard(meter)),
                  ],
                ),
              ),
              const SizedBox(height: 40),
              Expanded(
                child: _meters.isNotEmpty
                    ? ListView.builder(
                        itemCount: _meters.length,
                        itemBuilder: (context, index) {
                          final meter = _meters[index];
                          return Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            margin: const EdgeInsets.symmetric(vertical: 10),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Meter Name: ${meter.meterName}',
                                    style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    'Meter Number: ${meter.meterNumber}',
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    'Customer Name: ${meter.customerName}',
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    'Customer Number: ${meter.customerNumber}',
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    'Location: ${meter.location}',
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      )
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.insert_drive_file,
                            size: 80,
                            color: Colors.grey[300],
                          ),
                          const SizedBox(height: 20),
                          Text(
                            'No meters found',
                            style: TextStyle(
                              fontSize: 24,
                              color: Colors.grey[300],
                            ),
                          ),
                        ],
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAddMeterCard(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => EnterMeterNumberPage(onAddMeter: _addMeter),
          ),
        ).then((_) => _fetchMeters()); // Refresh meters after adding
      },
      child: Container(
        width: MediaQuery.of(context).size.width * 0.8, // Make card wider
        height: 200,
        margin: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
        decoration: BoxDecoration(
          color: Colors.teal[700],
          borderRadius: BorderRadius.circular(15),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 10,
              spreadRadius: 1,
              offset: Offset(0, 5),
            ),
          ],
        ),
        child: const Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.add,
                size: 50,
                color: Colors.white,
              ),
              SizedBox(height: 10),
              Text(
                'Add Meter',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMeterCard(Meter meter) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => UsagePage(meter: meter),
          ),
        );
      },
      child: Container(
        width: MediaQuery.of(context).size.width * 0.8, // Make card wider
        height: 220, // Adjust height to accommodate the button
        margin: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
        decoration: BoxDecoration(
          color: Colors.blueGrey[800],
          borderRadius: BorderRadius.circular(15),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 10,
              spreadRadius: 1,
              offset: Offset(0, 5),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    meter.meterName,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    'Meter Number: ${meter.meterNumber}',
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
              const Align(
                alignment: Alignment.bottomRight,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.electric_meter, color: Colors.white70, size: 18),
                    SizedBox(width: 5),
                    Text(
                      'Meter Details',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                      ),
                    ),
                    Text(
                      '100KW',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 18,
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(
                  height: 10), // Add spacing between details and button
              Align(
                alignment: Alignment.bottomRight,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              PaymentPage(meterId: meter.meterId)),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.teal, // Text color
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                  ),
                  child: const Text('Buy Credit'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
