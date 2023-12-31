import 'dart:convert';
import 'dart:io';

import 'package:app_fleet/app/config/domain/workspace_entity.dart';
import 'package:app_fleet/constants/storage_keys.dart';
import 'package:app_fleet/core/json_configurator.dart';
import 'package:app_fleet/utils/utils.dart';

class AppConfiguration extends JsonConfigurator {
  AppConfiguration({required super.configName});

  void writeWorkspace(WorkspaceEntity workspaceEntity) {
    File(combineHomePath(
            ['.config', "app-fleet", 'workspaces', toWorkspaceStorageName(workspaceEntity)]))
        .writeAsStringSync(jsonEncoder.convert(workspaceEntity.toMap()));
    add(StorageKeys.workspacesKey, toWorkspaceStorageName(workspaceEntity));
  }

  void deleteWorkspace(WorkspaceEntity workspaceEntity) {
    final workspaceFile = File(combineHomePath(
        ['.config', "app-fleet", 'workspaces', toWorkspaceStorageName(workspaceEntity)]));
    if (workspaceFile.existsSync()) {
      workspaceFile.deleteSync();
    }
    remove(StorageKeys.workspacesKey, toWorkspaceStorageName(workspaceEntity));
  }

  WorkspaceEntity readWorkspace(String name) {
    String data = File(combineHomePath(
            ['.config', "app-fleet", 'workspaces', fromWorkspaceStorageName(name)]))
        .readAsStringSync();
    return WorkspaceEntity.fromMap(jsonDecode(data));
  }
}
