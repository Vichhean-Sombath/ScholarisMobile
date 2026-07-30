class AttendanceHistory {
  const AttendanceHistory({
    required this.summary,
    required this.records,
  });

  final AttendanceSummary summary;
  final List<AttendanceRecord> records;
}

class AttendanceSummary {
  const AttendanceSummary({
    required this.present,
    required this.absent,
    required this.late,
    required this.excused,
    required this.total,
    required this.presentRate,
  });

  final int present;
  final int absent;
  final int late;
  final int excused;
  final int total;
  final double presentRate;

  factory AttendanceSummary.fromJson(Map<String, dynamic> json) {
    return AttendanceSummary(
      present: json['present'] as int? ?? 0,
      absent: json['absent'] as int? ?? 0,
      late: json['late'] as int? ?? 0,
      excused: json['excused'] as int? ?? 0,
      total: json['total'] as int? ?? 0,
      presentRate: (json['presentRate'] as num? ?? 0).toDouble(),
    );
  }
}

class AttendanceRecord {
  const AttendanceRecord({
    this.attendanceId,
    this.scheduleId,
    required this.className,
    required this.subjectName,
    required this.dayOfWeek,
    required this.startTime,
    required this.endTime,
    required this.attendanceDate,
    required this.status,
    required this.markedBy,
  });

  final int? attendanceId;
  final int? scheduleId;
  final String className;
  final String subjectName;
  final String dayOfWeek;
  final String startTime;
  final String endTime;
  final String attendanceDate;
  final String status;
  final String markedBy;

  factory AttendanceRecord.fromJson(Map<String, dynamic> json) {
    return AttendanceRecord(
      attendanceId: json['attendanceId'] as int?,
      scheduleId: json['scheduleId'] as int?,
      className: json['className'] as String? ?? '',
      subjectName: json['subjectName'] as String? ?? '',
      dayOfWeek: json['dayOfWeek'] as String? ?? '',
      startTime: json['startTime'] as String? ?? '',
      endTime: json['endTime'] as String? ?? '',
      attendanceDate: json['attendanceDate'] as String? ?? '',
      status: json['status'] as String? ?? '',
      markedBy: json['markedBy'] as String? ?? '',
    );
  }
}
