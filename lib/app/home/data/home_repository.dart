import 'dart:convert';
import 'dart:io';

import 'package:app_fleet/app/config/domain/workspace_entity.dart';
import 'package:app_fleet/core/app_configuration.dart';
import 'package:app_fleet/core/dependency_manager.dart';
import 'package:app_fleet/utils/utils.dart';

class HomeRepository {
  final storage = DependencyInjection.find<AppConfiguration>();

  Set<WorkspaceEntity> getWorkspaces() {
    Set<dynamic> configs = storage.get('workspaces').toList()!.toSet();
    Set<WorkspaceEntity> workspaces = {};
    for (var configName in configs) {
      var contents = File(combinePath(['.config', 'workspaces', configName]))
          .readAsStringSync();
      workspaces.add(WorkspaceEntity.fromMap(jsonDecode(contents)));
    }
    return workspaces;
  }

  bool anyWorkspaceConfigExists() {
    List<dynamic>? configs = (storage.get('workspaces') ?? []).toList();
    if (configs != null) {
      List<dynamic>? validConfigs = configs
          .where((e) =>
              File(combinePath(['.config', 'workspaces', e])).existsSync())
          .toList();
      configs = validConfigs;
      storage.put('workspaces', configs);
    }
    return configs != null && configs.isNotEmpty;
  }
}
