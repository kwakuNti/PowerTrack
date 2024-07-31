import 'dart:convert';

class MeterUsage {
  final int usageId;
  final int meterId;
  final double usage;
  final DateTime usageDate;

  MeterUsage({
    required this.usageId,
    required this.meterId,
    required this.usage,
    required this.usageDate,
  });

  factory MeterUsage.fromJson(Map<String, dynamic> json) {
    return MeterUsage(
      usageId: json['usage_id'],
      meterId: json['meter_id'],
      usage: json['usage'].toDouble(),
      usageDate: DateTime.parse(json['usage_date']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'usage_id': usageId,
      'meter_id': meterId,
      'usage': usage,
      'usage_date': usageDate.toIso8601String(),
    };
  }
}
