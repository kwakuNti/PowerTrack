import 'package:flutter/material.dart';
import 'package:frontend/main.dart';
import 'package:provider/provider.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import '../models/Meter.dart'; // Make sure to import the correct Meter class
import '../services/auth_services.dart';
import '../providers/auth_provider.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class EnterMeterNumberPage extends StatefulWidget {
  final Function(Meter) onAddMeter;

  const EnterMeterNumberPage({super.key, required this.onAddMeter});

  @override
  State<EnterMeterNumberPage> createState() => _EnterMeterNumberPageState();
}

class _EnterMeterNumberPageState extends State<EnterMeterNumberPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _meterNameController = TextEditingController();
  final TextEditingController _meterNumberController = TextEditingController();
  final TextEditingController _customerNameController = TextEditingController();
  final TextEditingController _customerNumberController =
      TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  final AuthService _authService = AuthService();
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> showNotification(String title, String body) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'channel_id', // Change this to your own channel ID
      'channel_name', // Change this to your own channel name
      channelDescription:
          'channel_description', // Change this to your own description
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'ticker',
    );

    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.show(
      0, // Notification ID
      title,
      body,
      platformChannelSpecifics,
      payload: 'item x', // Optional payload data
    );
  }

  Future<void> _getCurrentLocation() async {
    print('Requesting location permissions...');
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      print('Location services are disabled.');
      setState(() {
        _errorMessage = 'Location services are disabled.';
      });
      return;
    }

    // Check location permissions
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      print('Location permissions are denied. Requesting permission...');
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        print('Location permissions are still denied.');
        setState(() {
          _errorMessage = 'Location permissions are denied.';
        });
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      print('Location permissions are permanently denied.');
      setState(() {
        _errorMessage = 'Location permissions are permanently denied.';
      });
      return;
    }

    // Get current position
    print('Fetching current position...');
    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      print(
          'Position retrieved: Latitude = ${position.latitude}, Longitude = ${position.longitude}');

      // Get placemarks from position
      List<Placemark> placemarks =
          await placemarkFromCoordinates(position.latitude, position.longitude);

      if (placemarks.isNotEmpty) {
        Placemark placemark = placemarks[0];
        // Handle null values in placemark
        String street = placemark.street ?? '';
        String locality = placemark.locality ?? '';
        String country = placemark.country ?? '';

        String address = '$street, $locality, $country';
        print('Address retrieved: $address');

        setState(() {
          _addressController.text = address;
        });
      } else {
        print('No placemarks found for the given coordinates.');
        setState(() {
          _errorMessage = 'Could not find an address for the location.';
        });
      }
    } catch (e) {
      print('Error occurred while fetching location: $e');
      setState(() {
        _errorMessage = 'Failed to get address: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Enter Meter Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : Form(
                key: _formKey,
                child: ListView(
                  children: [
                    if (_errorMessage != null)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 16.0),
                        child: Text(
                          _errorMessage!,
                          style:
                              const TextStyle(color: Colors.red, fontSize: 16),
                        ),
                      ),
                    _buildRoundedTextField(_meterNameController, 'Meter Name'),
                    const SizedBox(height: 20),
                    _buildRoundedTextField(
                        _meterNumberController, 'Meter Number'),
                    const SizedBox(height: 20),
                    _buildRoundedTextField(
                        _customerNameController, 'Customer Name'),
                    const SizedBox(height: 20),
                    _buildRoundedTextField(
                        _customerNumberController, 'Customer Number'),
                    const SizedBox(height: 20),
                    _buildRoundedTextField(_addressController, 'Address'),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _handleAddMeter,
                      child: const Text('Add Meter'),
                    ),
                  ],
                ),
              ),
      ),
    );
  }

  void _handleAddMeter() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });

      final userId =
          Provider.of<AuthProvider>(context, listen: false).user?.user_id;
      if (userId == null) {
        setState(() {
          _isLoading = false;
          _errorMessage = 'User ID is null';
        });
        print('User ID is null');
        return;
      }

      final meterNumber = _meterNumberController.text;
      if (meterNumber.length != 11) {
        setState(() {
          _isLoading = false;
          _errorMessage = 'Meter Number must be 11 digits';
        });
        print('Meter Number must be 11 digits');
        return;
      }

      // Print entered details for debugging
      print('Meter Name: ${_meterNameController.text}');
      print('Meter Number: $meterNumber');
      print('Customer Name: ${_customerNameController.text}');
      print('Customer Number: ${_customerNumberController.text}');
      print('Address: ${_addressController.text}');
      print('User ID: $userId');

      try {
        final response = await _authService.createMeter(
          userId: userId,
          meterNumber: meterNumber,
          location: _addressController.text,
          meterName: _meterNameController.text,
          customerName: _customerNameController.text,
          customerNumber: _customerNumberController.text,
        );

        print('CreateMeter response: $response');

        if (response['status'] == 'success') {
          // Create Meter object without meterId if not returned
          final newMeter = Meter(
            meterId: 0, // Default to 0 if meter_id is not returned
            userId: userId,
            meterNumber: meterNumber,
            location: _addressController.text,
            meterName: _meterNameController.text,
            customerName: _customerNameController.text,
            customerNumber: _customerNumberController.text,
          );
          widget.onAddMeter(newMeter);
          Navigator.pop(context);
          showNotification('Power', 'A new meter has been successfully added.');
        } else {
          setState(() {
            _errorMessage = response['message'] ?? 'Failed to add meter';
          });
          print('Failed to add meter: ${response['message']}');
        }
      } catch (e) {
        setState(() {
          _errorMessage = 'An error occurred: $e';
        });
        print('Error during meter creation: $e');
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Widget _buildRoundedTextField(
      TextEditingController controller, String label) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        labelText: label,
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter $label';
        }
        return null;
      },
    );
  }
}
