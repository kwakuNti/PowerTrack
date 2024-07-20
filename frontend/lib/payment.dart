import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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
        backgroundColor: Colors.blue.shade50,
      ),
      body: SingleChildScrollView(
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(
                  'assets/pattern.png'), // Add your minimal pattern image in the assets folder
              fit: BoxFit.cover,
            ),
          ),
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Select Payment Method',
                style: GoogleFonts.poppins(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 10.0),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.9),
                  borderRadius: BorderRadius.circular(10.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 5.0,
                      spreadRadius: 2.0,
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    ListTile(
                      title: Text(
                        'Mobile Money',
                        style: GoogleFonts.poppins(),
                      ),
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
                      title: Text(
                        'Card (Visa)',
                        style: GoogleFonts.poppins(),
                      ),
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
                  ],
                ),
              ),
              const SizedBox(height: 20.0),
              if (_paymentMethod == 'momo') MobileMoneyForm(),
              if (_paymentMethod == 'card') CardPaymentForm(),
              const SizedBox(height: 30.0),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    // Handle payment submission logic here
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    padding:
                        EdgeInsets.symmetric(horizontal: 50.0, vertical: 15.0),
                    textStyle: GoogleFonts.poppins(fontSize: 16.0),
                  ),
                  child: const Text('Submit Payment'),
                ),
              ),
            ],
          ),
        ),
      ),
      backgroundColor: Colors.blue.shade50,
    );
  }
}

class MobileMoneyForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(10.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 5.0,
            spreadRadius: 2.0,
          ),
        ],
      ),
      child: Column(
        children: [
          TextField(
            style: GoogleFonts.poppins(),
            decoration: InputDecoration(
              labelText: 'MoMo Number',
              labelStyle: GoogleFonts.poppins(),
            ),
            keyboardType: TextInputType.number,
          ),
        ],
      ),
    );
  }
}

class CardPaymentForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(10.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 5.0,
            spreadRadius: 2.0,
          ),
        ],
      ),
      child: Column(
        children: [
          TextField(
            style: GoogleFonts.poppins(),
            decoration: InputDecoration(
              labelText: 'Card Number',
              labelStyle: GoogleFonts.poppins(),
            ),
            keyboardType: TextInputType.number,
          ),
          TextField(
            style: GoogleFonts.poppins(),
            decoration: InputDecoration(
              labelText: 'Expiry Date',
              labelStyle: GoogleFonts.poppins(),
            ),
            keyboardType: TextInputType.datetime,
          ),
          TextField(
            style: GoogleFonts.poppins(),
            decoration: InputDecoration(
              labelText: 'CVV',
              labelStyle: GoogleFonts.poppins(),
            ),
            keyboardType: TextInputType.number,
            obscureText: true,
          ),
        ],
      ),
    );
  }
}
