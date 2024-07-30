<?php
class Meter {
  final int meterId;
  final int userId;
  final String meterNumber;
  final String location;

  Meter({
    required this.meterId,
    required this.userId,
    required this.meterNumber,
    required this.location,
  });

  // Factory constructor to create a Meter object from JSON
  factory Meter.fromJson(Map<String, dynamic> json) {
    return Meter(
      meterId: json['meter_id'],
      userId: json['user_id'],
      meterNumber: json['meter_number'],
      location: json['location'],
    );
  }

  // Convert a Meter object to JSON
  Map<String, dynamic> toJson() {
    return {
      'meter_id': meterId,
      'user_id': userId,
      'meter_number': meterNumber,
      'location': location,
    };
  }
}
