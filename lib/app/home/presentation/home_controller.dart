import 'dart:ui';

import 'package:app_fleet/app/config/domain/workspace_entity.dart';
import 'package:app_fleet/app/home/data/home_repository.dart';
import 'package:app_fleet/app/home/presentation/home_state_machine.dart';
import 'package:app_fleet/core/dependency_manager.dart';
import 'package:app_fleet/core/route_service.dart';

class HomeController {
  final VoidCallback _onRebuildRequested;
  final HomeRepository _repository = DependencyInjection.find<HomeRepository>();
  late HomeState _currentState;

  HomeController({required void Function() onRebuildRequested})
      : _onRebuildRequested = onRebuildRequested {
    if (!_repository.anyWorkspaceConfigExists()) {
      _currentState = HomeEmptyState();
    } else {
      _currentState = HomeInitializedState();
    }
  }

  void gotoCreateRoute({WorkspaceEntity? workspaceEntity}) {
    DependencyInjection.find<RouteService>().gotoRoute(
      RouteService.createRoute,
      arguments: workspaceEntity,
    );
  }

  Set<WorkspaceEntity> getWorkspaces() {
    return _repository.getWorkspaces();
  }

  void onEvent(HomeEvent event) {
    switch (event.runtimeType) {
      case HomeEmptyEvent:
        _currentState = HomeEmptyState();
      case HomeInitializedEvent:
        _currentState = HomeInitializedState();
    }
    refreshUI();
  }

  HomeState getCurrentState() {
    return _currentState;
  }

  void refreshUI() {
    _onRebuildRequested();
  }
}
