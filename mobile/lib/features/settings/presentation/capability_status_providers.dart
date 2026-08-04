import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../authentication/presentation/auth_controller.dart';
import '../data/capability_status.dart';
import '../data/capability_status_repository.dart';

final capabilityStatusRepositoryProvider = Provider<CapabilityStatusRepository>(
  (ref) => CapabilityStatusRepository(
    ref.watch(apiClientProvider),
    () => ref.read(tokenStorageProvider).readAccessToken(),
  ),
);

final capabilityStatusProvider =
    ChangeNotifierProvider.autoDispose<CapabilityStatusController>((ref) {
      final controller = CapabilityStatusController(
        ref.watch(capabilityStatusRepositoryProvider),
      );
      controller.load();
      return controller;
    });

class CapabilityStatusController extends ChangeNotifier {
  CapabilityStatusController(this._repository);
  final CapabilityStatusRepository _repository;
  CapabilityStatus? status;
  bool loading = false;
  String? error;

  Future<void> load() async {
    loading = true;
    error = null;
    notifyListeners();
    try {
      status = await _repository.fetch();
    } catch (_) {
      error = 'Backend capability status is unavailable.';
    } finally {
      loading = false;
      notifyListeners();
    }
  }
}
