import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/models/attendance_history.dart';
import '../../domain/repositories/student_repository.dart';
import 'dependency_providers.dart';
import 'ui_state.dart';

class AttendanceNotifier extends StateNotifier<UiState<AttendanceHistory>> {
  AttendanceNotifier(this._repository) : super(const UiLoading()) {
    load();
  }

  final StudentRepository _repository;

  Future<void> load() async {
    state = const UiLoading();
    final result = await _repository.getAttendanceHistory();
    state = result.when(
      success: UiSuccess.new,
      failure: (error) => UiError(error.message),
    );
  }
}

final attendanceProvider = StateNotifierProvider<AttendanceNotifier, UiState<AttendanceHistory>>((ref) {
  return AttendanceNotifier(ref.watch(studentRepositoryProvider));
});
