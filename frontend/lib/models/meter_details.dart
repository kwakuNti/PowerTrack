// lib/models/meter_details.dart

class MeterDetails {
  final String meterName;
  final String meterNumber;
  final String customerName;
  final String customerNumber;
  final String address;

  MeterDetails({
    required this.meterName,
    required this.meterNumber,
    required this.customerName,
    required this.customerNumber,
    required this.address,
  });
}
