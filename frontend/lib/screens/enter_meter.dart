import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/Meter.dart'; // Make sure to import the correct Meter class
import '../services/auth_services.dart';
import '../providers/auth_provider.dart';

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
          final newMeter = Meter(
            meterId: response['meter_id'],
            userId: userId,
            meterNumber: meterNumber,
            location: _addressController.text,
            meterName: _meterNameController.text,
            customerName: _customerNameController.text,
            customerNumber: _customerNumberController.text,
          );
          widget.onAddMeter(newMeter);
          Navigator.pop(context);
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
