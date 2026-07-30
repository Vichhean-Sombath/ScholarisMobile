class CheckInResult {
  const CheckInResult({
    required this.attendanceId,
    required this.scheduleId,
    required this.studentId,
    required this.attendanceDate,
    required this.status,
  });

  final int attendanceId;
  final int scheduleId;
  final int studentId;
  final String attendanceDate;
  final String status;

  factory CheckInResult.fromJson(Map<String, dynamic> json) {
    return CheckInResult(
      attendanceId: json['attendanceId'] as int? ?? 0,
      scheduleId: json['scheduleId'] as int? ?? 0,
      studentId: json['studentId'] as int? ?? 0,
      attendanceDate: json['attendanceDate'] as String? ?? '',
      status: json['status'] as String? ?? '',
    );
  }
}
