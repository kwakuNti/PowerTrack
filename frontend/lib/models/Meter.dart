class Meter {
  final int meterId;
  final int userId;
  final String meterNumber;
  final String location;
  final String meterName;
  final String customerName;
  final String customerNumber;

  Meter({
    required this.meterId,
    required this.userId,
    required this.meterNumber,
    required this.location,
    required this.meterName,
    required this.customerName,
    required this.customerNumber,
  });

  // Factory constructor to create a Meter object from JSON
  factory Meter.fromJson(Map<String, dynamic> json) {
    return Meter(
      meterId: json['meter_id'],
      userId: json['user_id'],
      meterNumber: json['meter_number'],
      location: json['location'],
      meterName: json['meter_name'],
      customerName: json['customer_name'],
      customerNumber: json['customer_number'],
    );
  }

  // Convert a Meter object to JSON
  Map<String, dynamic> toJson() {
    return {
      'meter_id': meterId,
      'user_id': userId,
      'meter_number': meterNumber,
      'location': location,
      'meter_name': meterName,
      'customer_name': customerName,
      'customer_number': customerNumber,
    };
  }
}
