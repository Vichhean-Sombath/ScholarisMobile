import '../../core/result.dart';
import '../models/attendance_history.dart';
import '../models/check_in_result.dart';
import '../models/qr_payload.dart';
import '../models/student_profile.dart';
import '../models/student_summary.dart';

abstract class StudentRepository {
  Future<Result<StudentSummary>> getSummary();
  Future<Result<AttendanceHistory>> getAttendanceHistory();
  Future<Result<StudentProfile>> getProfile();
  Future<Result<CheckInResult>> checkIn(QrPayload payload);
}
