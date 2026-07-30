class QrPayload {
  const QrPayload({
    required this.scheduleId,
    required this.date,
    required this.token,
  });

  final int scheduleId;
  final String date;
  final String token;

  factory QrPayload.fromJson(Map<String, dynamic> json) {
    return QrPayload(
      scheduleId: json['scheduleId'] as int? ?? 0,
      date: json['date'] as String? ?? '',
      token: json['token'] as String? ?? '',
    );
  }
}
