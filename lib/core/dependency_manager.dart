import 'package:app_fleet/app/config/data/config_repository.dart';
import 'package:app_fleet/app/home/data/home_repository.dart';
import 'package:app_fleet/app/launcher/data/launcher_repository.dart';
import 'package:app_fleet/config/assets/generators/linux_app_finder.dart';
import 'package:app_fleet/core/app_configuration.dart';
import 'package:app_fleet/core/app_session_status.dart';
import 'package:app_fleet/core/app_updater.dart';
import 'package:app_fleet/core/route_service.dart';
import 'package:app_fleet/main.dart';
import 'package:app_fleet/utils/workspace_launcher.dart';
import 'package:flutter/foundation.dart';

final class DependencyManager {
  Set<dynamic> dependencies = {};

  void put<T>(T t) {
    debugPrintApp("[Injector] Putting $T ...");
    dependencies.add(t);
  }

  T find<T>() {
    return dependencies.where((object) => object.runtimeType == T).first;
  }
}

final class DependencyInjection {
  static final DependencyManager _manager = DependencyManager();

  static void injectDependencies(VoidCallback onRebuildRequested) {
    _manager.put<RouteService>(
        RouteService.withState(onRebuildRequested: onRebuildRequested));

    _manager.put<LinuxAppFinder>(LinuxAppFinder());

    _manager.put<AppSession>(AppSession());

    _manager.put<AppUpdater>(AppUpdater());

    _manager.put<AppConfiguration>(
        AppConfiguration(configName: "app-settings.json"));

    _manager.put<WorkspaceLauncher>(WorkspaceLauncher());

    _manager.put<HomeRepository>(HomeRepository());
    _manager.put<ConfigRepository>(ConfigRepository());
    _manager.put<LauncherRepository>(LauncherRepository());
    onRebuildRequested();
  }

  static T find<T>() {
    return _manager.find<T>();
  }

  static void put<T>(T t) {
    _manager.put<T>(t);
  }
}
