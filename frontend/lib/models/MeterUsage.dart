class MeterUsage {
  final int usageId;
  final int meterId;
  final int userId;
  final String usageDate;
  final String usageAmount;
  final String createdAt;

  MeterUsage({
    required this.usageId,
    required this.meterId,
    required this.userId,
    required this.usageDate,
    required this.usageAmount,
    required this.createdAt,
  });

  factory MeterUsage.fromJson(Map<String, dynamic> json) {
    return MeterUsage(
      usageId: json['usage_id'],
      meterId: json['meter_id'],
      userId: json['user_id'],
      usageDate: json['usage_date'],
      usageAmount: json['usage_amount'],
      createdAt: json['created_at'],
    );
  }
}
