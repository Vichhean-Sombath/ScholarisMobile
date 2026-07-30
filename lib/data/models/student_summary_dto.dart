import '../../domain/models/attendance_history.dart';
import '../../domain/models/student_summary.dart';

class StudentSummaryDto {
  const StudentSummaryDto({
    required this.profile,
    required this.kpis,
    required this.recentAttendance,
    required this.upcomingSchedule,
  });

  final ProfileDto profile;
  final KpisDto kpis;
  final List<AttendanceRecord> recentAttendance;
  final List<ScheduleItem> upcomingSchedule;

  factory StudentSummaryDto.fromJson(Map<String, dynamic> json) {
    return StudentSummaryDto(
      profile: ProfileDto.fromJson(json['profile'] as Map<String, dynamic>? ?? {}),
      kpis: KpisDto.fromJson(json['kpis'] as Map<String, dynamic>? ?? {}),
      recentAttendance: (json['recentAttendance'] as List? ?? [])
          .map((e) => AttendanceRecord.fromJson(e as Map<String, dynamic>))
          .toList(),
      upcomingSchedule: (json['upcomingSchedule'] as List? ?? [])
          .map((e) => ScheduleItem.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

class ProfileDto {
  const ProfileDto({this.fullName, this.email, this.status});

  final String? fullName;
  final String? email;
  final String? status;

  factory ProfileDto.fromJson(Map<String, dynamic> json) {
    return ProfileDto(
      fullName: json['fullName'] as String?,
      email: json['email'] as String?,
      status: json['status'] as String?,
    );
  }
}

class KpisDto {
  const KpisDto({
    this.classCount,
    this.scheduleCount,
    this.attendancePresentRate,
    this.attendanceTotal,
  });

  final int? classCount;
  final int? scheduleCount;
  final double? attendancePresentRate;
  final int? attendanceTotal;

  factory KpisDto.fromJson(Map<String, dynamic> json) {
    return KpisDto(
      classCount: json['classCount'] as int?,
      scheduleCount: json['scheduleCount'] as int?,
      attendancePresentRate: (json['attendancePresentRate'] as num?)?.toDouble(),
      attendanceTotal: json['attendanceTotal'] as int?,
    );
  }
}
