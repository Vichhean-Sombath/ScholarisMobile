import 'package:dio/dio.dart';

import '../../domain/models/check_in_result.dart';
import '../models/api_response.dart';
import '../models/attendance_response_dto.dart';
import '../models/check_in_dto.dart';
import '../models/student_profile_dto.dart';
import '../models/student_summary_dto.dart';
import 'api_client.dart';

class StudentApi {
  StudentApi(this._dio);

  final Dio _dio;

  Future<StudentSummaryDto> getSummary() async {
    try {
      final response = await _dio.get('/student/me/summary');
      return ApiResponse.fromJson(
        response.data as Map<String, dynamic>,
        (json) => StudentSummaryDto.fromJson(json as Map<String, dynamic>),
      ).data;
    } on DioException catch (e) {
      throw e.toAppException();
    }
  }

  Future<AttendanceResponseDto> getAttendance() async {
    try {
      final response = await _dio.get('/student/me/attendance');
      return ApiResponse.fromJson(
        response.data as Map<String, dynamic>,
        (json) => AttendanceResponseDto.fromJson(json as Map<String, dynamic>),
      ).data;
    } on DioException catch (e) {
      throw e.toAppException();
    }
  }

  Future<StudentProfileDto> getProfile() async {
    try {
      final response = await _dio.get('/student/me/profile');
      return ApiResponse.fromJson(
        response.data as Map<String, dynamic>,
        (json) => StudentProfileDto.fromJson(json as Map<String, dynamic>),
      ).data;
    } on DioException catch (e) {
      throw e.toAppException();
    }
  }

  Future<CheckInResult> checkIn(CheckInRequest request) async {
    try {
      final response = await _dio.post(
        '/student/me/attendance/checkin',
        data: request.toJson(),
      );
      return ApiResponse.fromJson(
        response.data as Map<String, dynamic>,
        (json) => CheckInResult.fromJson(json as Map<String, dynamic>),
      ).data;
    } on DioException catch (e) {
      throw e.toAppException();
    }
  }
}
