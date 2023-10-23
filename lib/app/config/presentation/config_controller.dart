import 'dart:ui';

import 'package:app_fleet/app/config/data/config_repository.dart';
import 'package:app_fleet/app/config/domain/workspace_entity.dart';
import 'package:app_fleet/app/config/presentation/config_state_machine.dart';
import 'package:app_fleet/constants/request_status.dart';
import 'package:app_fleet/core/dependency_manager.dart';
import 'package:app_fleet/core/logger.dart';
import 'package:app_fleet/core/route_service.dart';
import 'package:app_fleet/utils/utils.dart';
import 'package:url_launcher/url_launcher_string.dart';

class ConfigController {
  final VoidCallback _onRebuildRequested;
  final ConfigRepository _repository =
      DependencyInjection.find<ConfigRepository>();
  late ConfigState _currentState;

  ConfigController(
      {required void Function() onRebuildRequested, ConfigState? state})
      : _currentState = state ?? ConfigInitializationState(),
        _onRebuildRequested = onRebuildRequested;

  void gotoHomeRoute() {
    DependencyInjection.find<RouteService>().gotoRoute(RouteService.homeRoute);
  }

  void saveConfiguration(WorkspaceEntity workspaceEntity) {
    _repository.saveWorkspace(workspaceEntity: workspaceEntity);
    gotoHomeRoute();
  }

  void removeConfiguration(WorkspaceEntity workspaceEntity) {
    var result = _repository.deleteWorkspace(workspaceEntity: workspaceEntity);
    if (result == RequestStatus.success) {
      gotoHomeRoute();
    }
  }

  void openInDesktop(WorkspaceEntity workspaceEntity) {
    final url = getWorkspacePath(workspaceEntity.name);
    launchUrlString(url);
    prettyLog(
      value: url,
      type: DebugType.url,
    );
    gotoHomeRoute();
  }

  void onEvent(ConfigEvent event) {
    switch (event.runtimeType) {
      case ConfigInitializationEvent:
        _currentState = ConfigInitializationState();
        break;
      case ConfigInitializedEvent:
        _currentState = ConfigInitializedState(
            workspaceEntity: (event as ConfigInitializedEvent).workspaceEntity);
    }
    refreshUI();
  }

  ConfigState getCurrentState() {
    return _currentState;
  }

  void refreshUI() {
    _onRebuildRequested();
  }
}
