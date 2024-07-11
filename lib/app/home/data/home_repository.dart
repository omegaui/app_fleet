import 'dart:convert';
import 'dart:io';

import 'package:app_fleet/app/config/domain/workspace_entity.dart';
import 'package:app_fleet/core/app_configuration.dart';
import 'package:app_fleet/core/dependency_manager.dart';
import 'package:app_fleet/core/logger.dart';
import 'package:app_fleet/utils/utils.dart';

class HomeRepository {
  final storage = DependencyInjection.find<AppConfiguration>();

  Set<WorkspaceEntity> getWorkspaces() {
    Set<dynamic> configs = storage.get('workspaces').toList()!.toSet();
    Set<WorkspaceEntity> workspaces = {};
    for (var configName in configs) {
      var contents = File(combineHomePath(
              ['.config', "app-fleet", 'workspaces', configName]))
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
              File(combineHomePath(['.config', "app-fleet", 'workspaces', e]))
                  .existsSync())
          .toList();
      configs = validConfigs;
      storage.put('workspaces', configs);
    }
    return configs != null && configs.isNotEmpty;
  }

  Future<bool> isWMCTRLComponentInstalled() async {
    bool result = false;
    try {
      final processResult = await Process.run('wmctrl', ['--help']);
      result = processResult.exitCode == 0;
    } catch (e) {
      prettyLog(
        value:
            "Couldn't detect 'wmctrl' on this computer, APP FLEET WONT BE ABLE TO SWITCH WORKSPACES !!!",
        type: DebugType.error,
      );
      result = false;
    }
    return result;
  }
}
