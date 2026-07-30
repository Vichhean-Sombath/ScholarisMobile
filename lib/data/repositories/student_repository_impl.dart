import '../../core/errors.dart';
import '../../core/result.dart';
import '../../domain/models/attendance_history.dart';
import '../../domain/models/check_in_result.dart';
import '../../domain/models/qr_payload.dart';
import '../../domain/models/student_profile.dart';
import '../../domain/models/student_summary.dart';
import '../../domain/repositories/student_repository.dart';
import '../models/check_in_dto.dart';
import '../models/student_summary_dto.dart';
import '../services/student_api.dart';

class StudentRepositoryImpl implements StudentRepository {
  StudentRepositoryImpl({required StudentApi studentApi}) : _studentApi = studentApi;

  final StudentApi _studentApi;

  @override
  Future<Result<StudentSummary>> getSummary() async {
    try {
      final dto = await _studentApi.getSummary();
      return Result.success(_mapSummary(dto));
    } on AppException catch (e) {
      return Result.failure(e);
    } catch (e) {
      return Result.failure(AppException('Could not load dashboard: $e'));
    }
  }

  @override
  Future<Result<AttendanceHistory>> getAttendanceHistory() async {
    try {
      final dto = await _studentApi.getAttendance();
      return Result.success(
        AttendanceHistory(
          summary: dto.summary,
          records: dto.records,
        ),
      );
    } on AppException catch (e) {
      return Result.failure(e);
    } catch (e) {
      return Result.failure(AppException('Could not load attendance: $e'));
    }
  }

  @override
  Future<Result<StudentProfile>> getProfile() async {
    try {
      final dto = await _studentApi.getProfile();
      return Result.success(dto.toDomain());
    } on AppException catch (e) {
      return Result.failure(e);
    } catch (e) {
      return Result.failure(AppException('Could not load profile: $e'));
    }
  }

  @override
  Future<Result<CheckInResult>> checkIn(QrPayload payload) async {
    try {
      final request = CheckInRequest(
        scheduleId: payload.scheduleId,
        attendanceDate: payload.date,
        token: payload.token,
      );
      final result = await _studentApi.checkIn(request);
      return Result.success(result);
    } on AppException catch (e) {
      return Result.failure(e);
    } catch (e) {
      return Result.failure(AppException('Check-in failed: $e'));
    }
  }

  StudentSummary _mapSummary(StudentSummaryDto dto) {
    final profile = dto.profile;
    final kpis = dto.kpis;
    return StudentSummary(
      fullName: profile.fullName ?? '',
      email: profile.email ?? '',
      status: profile.status ?? '',
      classCount: kpis.classCount ?? 0,
      scheduleCount: kpis.scheduleCount ?? 0,
      attendancePresentRate: kpis.attendancePresentRate ?? 0.0,
      attendanceTotal: kpis.attendanceTotal ?? 0,
      recentAttendance: dto.recentAttendance,
      upcomingSchedule: dto.upcomingSchedule,
    );
  }
}
