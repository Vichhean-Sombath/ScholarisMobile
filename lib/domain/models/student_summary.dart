import 'attendance_history.dart';

class StudentSummary {
  const StudentSummary({
    required this.fullName,
    required this.email,
    required this.status,
    required this.classCount,
    required this.scheduleCount,
    required this.attendancePresentRate,
    required this.attendanceTotal,
    required this.recentAttendance,
    required this.upcomingSchedule,
  });

  final String fullName;
  final String email;
  final String status;
  final int classCount;
  final int scheduleCount;
  final double attendancePresentRate;
  final int attendanceTotal;
  final List<AttendanceRecord> recentAttendance;
  final List<ScheduleItem> upcomingSchedule;
}

class ScheduleItem {
  const ScheduleItem({
    this.scheduleId,
    required this.className,
    required this.subjectName,
    required this.teacherName,
    required this.dayOfWeek,
    required this.startTime,
    required this.endTime,
    required this.roomNumber,
  });

  final int? scheduleId;
  final String className;
  final String subjectName;
  final String teacherName;
  final String dayOfWeek;
  final String startTime;
  final String endTime;
  final String roomNumber;

  factory ScheduleItem.fromJson(Map<String, dynamic> json) {
    return ScheduleItem(
      scheduleId: json['scheduleId'] as int?,
      className: json['className'] as String? ?? '',
      subjectName: json['subjectName'] as String? ?? '',
      teacherName: json['teacherName'] as String? ?? '',
      dayOfWeek: json['dayOfWeek'] as String? ?? '',
      startTime: json['startTime'] as String? ?? '',
      endTime: json['endTime'] as String? ?? '',
      roomNumber: json['roomNumber'] as String? ?? '',
    );
  }
}
