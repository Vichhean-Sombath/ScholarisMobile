class CheckInRequest {
  const CheckInRequest({
    required this.scheduleId,
    required this.attendanceDate,
    required this.token,
  });

  final int scheduleId;
  final String attendanceDate;
  final String token;

  Map<String, dynamic> toJson() => {
    'schedule_id': scheduleId,
    'attendance_date': attendanceDate,
    'token': token,
  };
}
