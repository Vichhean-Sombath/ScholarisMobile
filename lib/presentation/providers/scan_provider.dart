import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/models/check_in_result.dart';
import '../../domain/models/qr_payload.dart';
import '../../domain/repositories/student_repository.dart';
import 'dependency_providers.dart';

sealed class ScanUiState {
  const ScanUiState();

  R when<R>({
    required R Function() scanning,
    required R Function() submitting,
    required R Function(CheckInResult result) success,
    required R Function(String message) error,
  }) {
    return switch (this) {
      ScanScanning() => scanning(),
      ScanSubmitting() => submitting(),
      ScanSuccess(:final result) => success(result),
      ScanError(:final message) => error(message),
    };
  }
}

class ScanScanning extends ScanUiState {
  const ScanScanning();
}

class ScanSubmitting extends ScanUiState {
  const ScanSubmitting();
}

class ScanSuccess extends ScanUiState {
  const ScanSuccess(this.result);

  final CheckInResult result;
}

class ScanError extends ScanUiState {
  const ScanError(this.message);

  final String message;
}

class ScanNotifier extends StateNotifier<ScanUiState> {
  ScanNotifier(this._repository) : super(const ScanScanning());

  final StudentRepository _repository;
  String? _lastScannedCode;

  Future<void> onQrDetected(String rawValue) async {
    if (rawValue == _lastScannedCode) return;
    _lastScannedCode = rawValue;

    final payload = _parseQrPayload(rawValue);
    if (payload == null) {
      state = const ScanError('Invalid QR code format.');
      return;
    }

    state = const ScanSubmitting();
    final result = await _repository.checkIn(payload);
    state = result.when(
      success: (data) => ScanSuccess(data),
      failure: (error) => ScanError(error.message),
    );
  }

  void resumeScanning() {
    _lastScannedCode = null;
    state = const ScanScanning();
  }

  QrPayload? _parseQrPayload(String rawValue) {
    try {
      final json = jsonDecode(rawValue) as Map<String, dynamic>;
      return QrPayload.fromJson(json);
    } catch (_) {
      return null;
    }
  }
}

final scanProvider = StateNotifierProvider<ScanNotifier, ScanUiState>((ref) {
  return ScanNotifier(ref.watch(studentRepositoryProvider));
});
