import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/models/student_profile.dart';
import '../../domain/repositories/student_repository.dart';
import 'dependency_providers.dart';
import 'ui_state.dart';

class ProfileNotifier extends StateNotifier<UiState<StudentProfile>> {
  ProfileNotifier(this._repository) : super(const UiLoading()) {
    load();
  }

  final StudentRepository _repository;

  Future<void> load() async {
    state = const UiLoading();
    final result = await _repository.getProfile();
    state = result.when(
      success: UiSuccess.new,
      failure: (error) => UiError(error.message),
    );
  }
}

final profileProvider = StateNotifierProvider<ProfileNotifier, UiState<StudentProfile>>((ref) {
  return ProfileNotifier(ref.watch(studentRepositoryProvider));
});
