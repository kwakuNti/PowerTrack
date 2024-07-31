import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:frontend/providers/auth_provider.dart';
import 'package:frontend/screens/transaction.dart';
import 'package:frontend/services/auth_services.dart';
import 'package:provider/provider.dart';

class PaymentPage extends StatefulWidget {
  final int meterId; // Updated to int

  PaymentPage({required this.meterId});

  @override
  _PaymentPageState createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _paymentMethodController =
      TextEditingController();
  bool _isLoading = false;
  String? _errorMessage;

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
                TextFormField(
                  controller: _amountController,
                  decoration: const InputDecoration(
                    labelText: 'Amount',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.attach_money),
                  ),
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
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
                TextFormField(
                  controller: _paymentMethodController,
                  decoration: const InputDecoration(
                    labelText: 'Payment Method',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.payment),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter payment method';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState?.validate() ?? false) {
                      final amount = double.parse(_amountController.text);
                      final paymentMethod = _paymentMethodController.text;

                      setState(() {
                        _isLoading = true;
                      });

                      final response = await _createTransaction(
                        userId: userId,
                        meterId: widget.meterId, // Using integer meterId
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
                        // Navigate to TransactionsScreen
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const TransactionsScreen(),
                          ),
                        );
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
    required int meterId, // Updated to int
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
