import 'package:flutter/material.dart';
import '/models/meter_details.dart';

class EnterMeterNumberPage extends StatefulWidget {
  final Function(MeterDetails) onAddMeter;

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Enter Meter Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              _buildRoundedTextField(_meterNameController, 'Meter Name'),
              const SizedBox(height: 20),
              _buildRoundedTextField(_meterNumberController, 'Meter Number'),
              const SizedBox(height: 20),
              _buildRoundedTextField(_customerNameController, 'Customer Name'),
              const SizedBox(height: 20),
              _buildRoundedTextField(
                  _customerNumberController, 'Customer Number'),
              const SizedBox(height: 20),
              _buildRoundedTextField(_addressController, 'Address'),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    final newMeter = MeterDetails(
                      meterName: _meterNameController.text,
                      meterNumber: _meterNumberController.text,
                      customerName: _customerNameController.text,
                      customerNumber: _customerNumberController.text,
                      address: _addressController.text,
                    );
                    widget.onAddMeter(newMeter);
                    Navigator.pop(context);
                  }
                },
                child: const Text('Add Meter'),
              ),
            ],
          ),
        ),
      ),
    );
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
