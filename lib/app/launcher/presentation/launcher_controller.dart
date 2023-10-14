import 'package:app_fleet/app/config/domain/workspace_entity.dart';
import 'package:app_fleet/app/launcher/data/launcher_repository.dart';
import 'package:app_fleet/app/launcher/presentation/launcher_state_machine.dart';
import 'package:app_fleet/constants/request_status.dart';
import 'package:app_fleet/core/dependency_manager.dart';
import 'package:flutter/foundation.dart';

class LauncherController {
  late LauncherState _currentState;
  late VoidCallback _onRebuildRequested;
  final LauncherRepository _repository =
      DependencyInjection.find<LauncherRepository>();

  LauncherController({required void Function() onRebuildRequested}) {
    _onRebuildRequested = onRebuildRequested;
    _currentState = LauncherEmptyState();
    loadFromDisk();
  }

  Set<WorkspaceEntity> getWorkspaces({required bool reload}) {
    return _repository.getWorkspaces(reload: reload);
  }

  RequestStatus launchWorkspaceManager() {
    return _repository.launchWorkspaceManager();
  }

  void launch(WorkspaceEntity workspaceEntity,
      {required void Function(String status) onProgress}) {
    _repository.launch(workspaceEntity, onProgress: onProgress);
  }

  void reloadFromDisk() {
    final workspaces = getWorkspaces(reload: true);
    if (workspaces.isNotEmpty) {
      onEvent(LauncherInitializedEvent(workspaces: workspaces));
    } else if (_currentState.runtimeType != LauncherEmptyEvent) {
      onEvent(LauncherEmptyEvent());
    }
  }

  void loadFromDisk() {
    final workspaces = getWorkspaces(reload: false);
    if (workspaces.isNotEmpty) {
      onEvent(LauncherInitializedEvent(workspaces: workspaces));
    } else if (_currentState.runtimeType != LauncherEmptyEvent) {
      onEvent(LauncherEmptyEvent());
    }
  }

  void onEvent(LauncherEvent event) {
    switch (event.runtimeType) {
      case LauncherEmptyEvent:
        _currentState = LauncherEmptyState();
        break;
      case LauncherInitializedEvent:
        _currentState = LauncherInitializedState(
            workspaces: (event as LauncherInitializedEvent).workspaces);
        break;
    }
    refreshUI();
  }

  LauncherState getCurrentState() {
    return _currentState;
  }

  void refreshUI() {
    _onRebuildRequested();
  }
}
