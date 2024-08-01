import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class QRScannerPage extends StatelessWidget {
  final Function(Map<String, dynamic>) onQRViewCreated;

  const QRScannerPage({Key? key, required this.onQRViewCreated})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('QR Scanner'),
        backgroundColor: Colors.teal,
      ),
      body: MobileScanner(
        onDetect: (BarcodeCapture capture) {
          final code = capture.barcodes.first.rawValue;
          if (code != null) {
            print('QR code detected: $code');
            final meterData = parseQRData(code);
            onQRViewCreated(meterData);
            Navigator.pop(context);
          } else {
            print('No barcode detected.');
          }
        },
        fit: BoxFit.cover,
        errorBuilder: (context, error, _) {
          return Center(
            child: Text('Error: $error'),
          );
        },
      ),
    );
  }

  Map<String, dynamic> parseQRData(String data) {
    try {
      final parsedData = Map<String, dynamic>.from(jsonDecode(data));
      print('Parsed QR data: $parsedData');
      return parsedData;
    } catch (e) {
      print('Error parsing QR data: $e');
      return {};
    }
  }
}
