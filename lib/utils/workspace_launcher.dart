import 'package:app_fleet/app/config/domain/workspace_entity.dart';
import 'package:app_fleet/app/launcher/data/launcher_repository.dart';
import 'package:app_fleet/app/settings/data/settings_repository.dart';
import 'package:app_fleet/core/app_session.dart';
import 'package:app_fleet/core/dependency_manager.dart';
import 'package:app_fleet/core/logger.dart';
import 'package:app_fleet/core/route_service.dart';
import 'package:app_fleet/utils/utils.dart';
import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class WorkspaceLauncher {
  bool launchStared = false;
  final AppSession session = DependencyInjection.find<AppSession>();

  void launch(
    WorkspaceEntity workspaceEntity, {
    required void Function(String status) onProgress,
  }) {
    if (launchStared) {
      return;
    }
    launchStared = false;
    onProgress(
        "$launchStartTag Launching Workspace ${workspaceEntity.name} ...");
    final workspaceMap = getMappedApps(workspaceEntity);

    void onComplete() {
      if (workspaceEntity.defaultWorkspace >= 0) {
        executeWorkspaceSwitcher(workspaceEntity.defaultWorkspace);
      }
      final settingsRepo = DependencyInjection.find<SettingsRepository>();
      if (!settingsRepo.getKeepAliveLauncher()) {
        Future.delayed(
          const Duration(seconds: 5),
          () {
            if (session.isClean) {
              appWindow.close();
              SystemNavigator.pop();
              if (RouteService.navigatorKey.currentContext != null) {
                Navigator.pop(RouteService.navigatorKey.currentContext!);
              }
            }
          },
        );
      } else {
        onProgress("$launchFinishedTag Done!");
      }
    }

    prettyLog(
      tag: "WorkspaceLauncher",
      value: "${workspaceMap.keys.length} workspaces can be launched.",
    );

    var entries = workspaceMap.entries;
    Future.delayed(
      const Duration(milliseconds: 0),
      () async {
        for (final e in entries) {
          var status = "Switching to workspace ${e.key + 1}";
          onProgress("$launchProgressTag $status");
          executeWorkspaceSwitcher(e.key);
          var apps = e.value;
          for (var app in apps) {
            status = "Launching ${app.name}, waiting ${app.waitTime} ms ...";
            onProgress("$launchProgressTag $status");
            await app.launch();
          }
        }

        var status = session.isClean
            ? "Workspace Successfully Launched"
            : "Error Encountered during Workspace Launch!";
        onProgress("$launchProgressTag $status");

        onComplete();
      },
    );
  }

  Map<int, List<App>> getMappedApps(WorkspaceEntity workspaceEntity) {
    Map<int, List<App>> workspaceMap = {};
    final apps = workspaceEntity.apps;
    for (final app in apps) {
      workspaceMap[app.priority] = [];
    }
    for (final app in apps) {
      workspaceMap[app.priority]!.add(app);
    }
    Map<int, List<App>> backup = {...workspaceMap};
    List<int> workspaces = workspaceMap.keys.toList()..sort();
    workspaceMap = {};
    for (var workspace in workspaces) {
      workspaceMap[workspace] = backup[workspace]!;
    }
    return workspaceMap;
  }
}
