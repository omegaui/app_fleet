import 'package:app_fleet/app/config/domain/workspace_entity.dart';

class ConfigState {}

class ConfigInitializationState extends ConfigState {}

class ConfigInitializedState extends ConfigState {
  final WorkspaceEntity workspaceEntity;

  ConfigInitializedState({required this.workspaceEntity});
}

class ConfigEvent {}

class ConfigInitializationEvent extends ConfigEvent {}

class ConfigInitializedEvent extends ConfigEvent {
  final WorkspaceEntity workspaceEntity;

  ConfigInitializedEvent({required this.workspaceEntity});
}
