import 'dart:async';
import 'dart:ui';

import 'package:app_fleet/app/update/data/update_repository.dart';
import 'package:app_fleet/app/update/presentation/update_state_machine.dart';
import 'package:app_fleet/core/app_updater.dart';
import 'package:app_fleet/core/dependency_manager.dart';

class UpdateController {
  final VoidCallback _onRebuildRequested;
  final UpdateRepository _repository =
      DependencyInjection.find<UpdateRepository>();
  late UpdateState _currentState;

  UpdateController({required void Function() onRebuildRequested})
      : _onRebuildRequested = onRebuildRequested {
    _currentState = UpdateEmptyState();
  }

  void showUpdatePage({bool reinstall = false}) {
    onEvent(UpdateInitializedEvent(reinstall));
  }

  Future<StreamSubscription<List<int>>?> invokeUpdater({
    required UpdateData data,
    required void Function(int progress) onProgress,
    required void Function(List<int> bytes) onComplete,
    required void Function(dynamic error) onError,
    required VoidCallback onStartFailure,
  }) {
    return _repository.startUpdate(
      data: data,
      onProgress: onProgress,
      onComplete: onComplete,
      onError: onError,
      onStartFailure: onStartFailure,
    );
  }

  void onEvent(UpdateEvent event) {
    switch (event.runtimeType) {
      case UpdateEmptyEvent:
        _currentState = UpdateEmptyState();
      case UpdateInitializedEvent:
        _currentState =
            UpdateInitializedState((event as UpdateInitializedEvent).reinstall);
    }
    refreshUI();
  }

  UpdateState getCurrentState() {
    return _currentState;
  }

  void refreshUI() {
    _onRebuildRequested();
  }
}
