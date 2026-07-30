import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/models/student_summary.dart';
import '../../domain/repositories/student_repository.dart';
import 'dependency_providers.dart';
import 'ui_state.dart';

class DashboardNotifier extends StateNotifier<UiState<StudentSummary>> {
  DashboardNotifier(this._repository) : super(const UiLoading()) {
    load();
  }

  final StudentRepository _repository;

  Future<void> load() async {
    state = const UiLoading();
    final result = await _repository.getSummary();
    state = result.when(
      success: UiSuccess.new,
      failure: (error) => UiError(error.message),
    );
  }
}

final dashboardProvider = StateNotifierProvider<DashboardNotifier, UiState<StudentSummary>>((ref) {
  return DashboardNotifier(ref.watch(studentRepositoryProvider));
});
