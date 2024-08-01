import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:frontend/providers/auth_provider.dart';
import 'package:frontend/services/auth_services.dart';
import 'package:provider/provider.dart';
import 'home.dart';
import 'package:frontend/main.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class PaymentPage extends StatefulWidget {
  final int meterId;

  PaymentPage({required this.meterId});

  @override
  _PaymentPageState createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _amountController = TextEditingController();
  bool _isLoading = false;
  String? _errorMessage;
  String? _selectedPaymentMethod;

  final List<String> _paymentMethods = ['Card', 'Mobile Money'];

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

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final userId = authProvider.user?.user_id;

    if (userId == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Payment'),
          backgroundColor: Colors.blueAccent,
        ),
        body: const Center(child: Text('User ID is not available')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const Text(
                  'Enter Payment Details',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                if (_errorMessage != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: Text(
                      _errorMessage!,
                      style: const TextStyle(color: Colors.red),
                    ),
                  ),
                Card(
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        TextFormField(
                          controller: _amountController,
                          decoration: const InputDecoration(
                            labelText: 'Amount',
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.attach_money),
                          ),
                          keyboardType: const TextInputType.numberWithOptions(
                              decimal: true),
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter an amount';
                            }
                            if (double.tryParse(value) == null) {
                              return 'Please enter a valid amount';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        DropdownButtonFormField<String>(
                          value: _selectedPaymentMethod,
                          items: _paymentMethods
                              .map((method) => DropdownMenuItem(
                                    value: method,
                                    child: Text(method),
                                  ))
                              .toList(),
                          onChanged: (value) {
                            setState(() {
                              _selectedPaymentMethod = value;
                            });
                          },
                          decoration: const InputDecoration(
                            labelText: 'Payment Method',
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please select a payment method';
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState?.validate() ?? false) {
                      final amount = double.parse(_amountController.text);
                      final paymentMethod = _selectedPaymentMethod ?? '';

                      setState(() {
                        _isLoading = true;
                      });

                      final response = await _createTransaction(
                        userId: userId,
                        meterId: widget.meterId,
                        amount: amount,
                        paymentMethod: paymentMethod,
                        transactionStatus: 'complete',
                      );

                      setState(() {
                        _isLoading = false;
                      });

                      if (response['status'] == 'success') {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Payment successful')),
                        );
                        // Navigate to HomePage
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const HomePage(),
                          ),
                        );
                        showNotification('PowerTrack', 'Payment successful');
                        showNotification(
                            'PowerTrack', 'A new transaction was made');
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content:
                                Text('Payment failed: ${response['message']}'),
                          ),
                        );
                      }
                    }
                  },
                  child: _isLoading
                      ? const CircularProgressIndicator()
                      : const Text('Submit Payment'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<Map<String, dynamic>> _createTransaction({
    required int userId,
    required int meterId,
    required double amount,
    required String paymentMethod,
    required String transactionStatus,
  }) async {
    try {
      final authService = AuthService();
      final response = await authService.createTransaction(
        userId: userId,
        meterId: meterId,
        amount: amount,
        paymentMethod: paymentMethod,
        transactionStatus: transactionStatus,
      );

      return response;
    } catch (e) {
      print('Error during createTransaction: $e');
      return {'status': 'error', 'message': 'Failed to create transaction'};
    }
  }
}
