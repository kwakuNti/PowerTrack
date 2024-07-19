import 'package:flutter/material.dart';

class PaymentPage extends StatefulWidget {
  final String meterId;

  PaymentPage({required this.meterId});

  @override
  _PaymentPageState createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  String _paymentMethod = 'momo';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Payment for Meter ${widget.meterId}'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Select Payment Method',
              style: TextStyle(fontSize: 18.0),
            ),
            ListTile(
              title: const Text('Mobile Money'),
              leading: Radio<String>(
                value: 'momo',
                groupValue: _paymentMethod,
                onChanged: (String? value) {
                  setState(() {
                    _paymentMethod = value!;
                  });
                },
              ),
            ),
            ListTile(
              title: const Text('Card (Visa)'),
              leading: Radio<String>(
                value: 'card',
                groupValue: _paymentMethod,
                onChanged: (String? value) {
                  setState(() {
                    _paymentMethod = value!;
                  });
                },
              ),
            ),
            if (_paymentMethod == 'momo') MobileMoneyForm(),
            if (_paymentMethod == 'card') CardPaymentForm(),
            const SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                // Handle payment submission logic here
              },
              child: const Text('Submit Payment'),
            ),
          ],
        ),
      ),
    );
  }
}

class MobileMoneyForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        TextField(
          decoration: InputDecoration(labelText: 'MoMo Number'),
        ),
      ],
    );
  }
}

class CardPaymentForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        TextField(
          decoration: InputDecoration(labelText: 'Card Number'),
        ),
        TextField(
          decoration: InputDecoration(labelText: 'Expiry Date'),
        ),
        TextField(
          decoration: InputDecoration(labelText: 'CVV'),
        ),
      ],
    );
  }
}
