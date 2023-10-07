import 'package:app_fleet/app/config/domain/workspace_entity.dart';

class LauncherState {}

class LauncherEmptyState extends LauncherState {}

class LauncherInitializedState extends LauncherState {
  final Set<WorkspaceEntity> workspaces;

  LauncherInitializedState({required this.workspaces});
}

class LauncherEvent {}

class LauncherEmptyEvent extends LauncherEvent {}

class LauncherInitializedEvent extends LauncherEvent {
  final Set<WorkspaceEntity> workspaces;

  LauncherInitializedEvent({required this.workspaces});
}
