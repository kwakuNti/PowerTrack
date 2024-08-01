import 'package:flutter/material.dart';
import 'package:frontend/providers/auth_provider.dart';
import 'package:frontend/screens/qr.dart';
import 'package:frontend/services/auth_services.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'enter_meter.dart';
import '/models/Meter.dart';
import '/models/MeterUsage.dart'; // Import the MeterUsage model
import 'payment.dart';
import 'usagepage.dart'; // Import the UsagePage
import 'qr.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

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

  // Map to store meter usages
  final Map<int, double> _meterUsages = {};

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

      // Fetch usage for each meter
      for (var meter in meters) {
        final usageData =
            await _authService.getMeterUsageByMeterId(meter.meterId);
        // Sum up the usage amounts
        double totalUsage = usageData.fold(
            0, (sum, usage) => sum + double.parse(usage.usageAmount));
        setState(() {
          _meterUsages[meter.meterId] = totalUsage;
        });
      }
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

  Future<void> _onQRScanned(Map<String, dynamic> meterData) async {
    final userId =
        Provider.of<AuthProvider>(context, listen: false).user?.user_id;
    if (userId == null) {
      setState(() {
        _errorMessage = 'User ID is null';
      });
      print('User ID is null');
      return;
    }

    try {
      final response = await _authService.createMeter(
        userId: userId,
        meterNumber: meterData['meterNumber'] ?? '',
        location: meterData['location'] ?? '',
        meterName: meterData['meterName'] ?? '',
        customerName: meterData['customerName'] ?? '',
        customerNumber: meterData['customerNumber'] ?? '',
      );

      if (response['status'] == 'success') {
        final meter = Meter(
          meterName: meterData['meterName'] ?? '',
          meterNumber: meterData['meterNumber'] ?? '',
          customerName: meterData['customerName'] ?? '',
          customerNumber: meterData['customerNumber'] ?? '',
          location: meterData['location'] ?? '',
          meterId: response['meter_id'] ?? 0,
          userId: userId,
        );
        _addMeter(meter);
        print('Meter successfully created: $meter');
      } else {
        print('Failed to create meter: ${response['message']}');
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'An error occurred: $e';
      });
      print('Error during meter creation: $e');
    }
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
                    _buildScanQRCard(
                        context), // Add this line to include the QR scan card

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
    final usageAmount =
        _meterUsages[meter.meterId] ?? 0.0; // Fetch the usage amount
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => UsagePage(meter: meter, usage: usageAmount),
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
              Align(
                alignment: Alignment.bottomRight,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.electric_meter,
                        color: Colors.white70, size: 18),
                    SizedBox(width: 5),
                    const Text(
                      'Meter Usage:',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                      ),
                    ),
                    SizedBox(width: 10),
                    Text(
                      '${usageAmount.toStringAsFixed(2)} KW',
                      style: const TextStyle(
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

  Widget _buildScanQRCard(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => QRScannerPage(
              onQRViewCreated: (meterData) async {
                await _onQRScanned(meterData);
                await _fetchMeters();
              },
            ),
          ),
        );
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
                Icons.qr_code_scanner,
                size: 50,
                color: Colors.white,
              ),
              SizedBox(height: 10),
              Text(
                'Scan QR Code',
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
}
