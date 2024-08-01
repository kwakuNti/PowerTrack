import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'dart:convert';

class QRScannerPage extends StatefulWidget {
  final Function(Map<String, dynamic>) onQRViewCreated;

  QRScannerPage({required this.onQRViewCreated});

  @override
  _QRScannerPageState createState() => _QRScannerPageState();
}

class _QRScannerPageState extends State<QRScannerPage> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? controller;
  bool scanned = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('QR Scanner'),
      ),
      body: Column(
        children: [
          Expanded(
            flex: 5,
            child: QRView(
              key: qrKey,
              onQRViewCreated: _onQRViewCreated,
            ),
          ),
          Expanded(
            flex: 1,
            child: Center(
              child: Text('Scan a QR code'),
            ),
          ),
        ],
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    print('QR View created');
    controller.scannedDataStream.listen((scanData) {
      if (!scanned && scanData.code != null) {
        scanned = true;
        print('QR code scanned: ${scanData.code}');
        Map<String, dynamic> meterData = _parseQRCode(scanData.code!);
        print('Parsed meter data: $meterData');
        widget.onQRViewCreated(meterData);
        print('Navigating back');
        Navigator.pop(context);
      }
    });
  }

  Map<String, dynamic> _parseQRCode(String qrData) {
    print('Received QR code data: $qrData');
    try {
      // Attempt to parse the QR code data as JSON
      Map<String, dynamic> jsonData = json.decode(qrData);
      print('Parsed JSON data: $jsonData');

      // Ensure all required fields are present
      var parsedData = {
        "meterName": jsonData['meter_name'] ?? '',
        "meterNumber": jsonData['meter_number'] ?? '',
        "customerName": jsonData['customer_name'] ?? '',
        "customerNumber": jsonData['customer_number'] ?? '',
        "location": jsonData['location'] ?? '',
        "meterId": jsonData['meter_id'] ?? 0,
        "userId": jsonData['user_id'] ?? 0,
      };

      print('Parsed meter data: $parsedData');
      return parsedData;
    } catch (e) {
      // If parsing fails, return a map with default values
      print('Error parsing QR code: $e');
      var defaultData = {
        "meterName": '',
        "meterNumber": '',
        "customerName": '',
        "customerNumber": '',
        "location": '',
        "meterId": 0,
        "userId": 0,
      };

      print('Returning default data: $defaultData');
      return defaultData;
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
