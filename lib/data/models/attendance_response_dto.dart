import '../../domain/models/attendance_history.dart';

class AttendanceResponseDto {
  const AttendanceResponseDto({
    required this.summary,
    required this.records,
  });

  final AttendanceSummary summary;
  final List<AttendanceRecord> records;

  factory AttendanceResponseDto.fromJson(Map<String, dynamic> json) {
    return AttendanceResponseDto(
      summary: AttendanceSummary.fromJson(json['summary'] as Map<String, dynamic>? ?? {}),
      records: (json['records'] as List? ?? [])
          .map((e) => AttendanceRecord.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}
