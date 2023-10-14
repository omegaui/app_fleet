import 'dart:io';

import 'package:app_fleet/app/config/domain/workspace_entity.dart';
import 'package:app_fleet/app/home/data/home_repository.dart';
import 'package:app_fleet/constants/request_status.dart';
import 'package:app_fleet/core/app_configuration.dart';
import 'package:app_fleet/core/dependency_manager.dart';
import 'package:app_fleet/main.dart';
import 'package:app_fleet/utils/workspace_launcher.dart';

const launchStartTag = '[Launching]';
const launchProgressTag = '[Launch Status]';
const launchFinishedTag = '[Launch Finished]';

class LauncherRepository {
  final storage = DependencyInjection.find<AppConfiguration>();
  final homeRepository = DependencyInjection.find<HomeRepository>();
  final workspaceLauncher = DependencyInjection.find<WorkspaceLauncher>();

  void launch(
    WorkspaceEntity workspaceEntity, {
    required void Function(String status) onProgress,
  }) {
    workspaceLauncher.launch(
      workspaceEntity,
      onProgress: onProgress,
    );
  }

  Set<WorkspaceEntity> getWorkspaces({required bool reload}) {
    if (reload) {
      storage.reload();
    }
    // Calling the anyWorkspaceConfigExists() validates the configs
    if (homeRepository.anyWorkspaceConfigExists()) {
      return homeRepository.getWorkspaces();
    }
    return {};
  }

  RequestStatus launchWorkspaceManager() {
    var executable = '/usr/bin/app-fleet';
    if (!File(executable).existsSync()) {
      debugPrintApp(
          "[Launcher] App Fleet hasn't been integrated with the system yet!");
      debugPrintApp(
          "[Launcher] place/map the executable to $executable to complete integration!");
      return RequestStatus.failed;
    }
    Process.start(executable, []);
    return RequestStatus.success;
  }

  RequestStatus launchWorkspaceLauncher() {
    var executable = '/usr/bin/app-fleet';
    if (!File(executable).existsSync()) {
      debugPrintApp(
          "[Launcher] App Fleet hasn't been integrated with the system yet!");
      debugPrintApp(
          "[Launcher] place/map the executable to $executable to complete integration!");
      return RequestStatus.failed;
    }
    Process.start(executable, ['--mode', 'launcher']);
    return RequestStatus.success;
  }
}
