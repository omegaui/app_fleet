import 'package:app_fleet/app/config/domain/workspace_entity.dart';
import 'package:app_fleet/constants/request_status.dart';
import 'package:app_fleet/core/app_configuration.dart';
import 'package:app_fleet/core/dependency_manager.dart';

class ConfigRepository {
  final storage = DependencyInjection.find<AppConfiguration>();

  void saveWorkspace({required WorkspaceEntity workspaceEntity}) {
    storage.writeWorkspace(workspaceEntity);
  }

  RequestStatus deleteWorkspace({required WorkspaceEntity workspaceEntity}) {
    storage.deleteWorkspace(workspaceEntity);
    return RequestStatus.success;
  }
}
