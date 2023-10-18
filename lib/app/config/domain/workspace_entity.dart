import 'package:app_fleet/config/assets/app_icons.dart';
import 'package:app_fleet/constants/storage_keys.dart';
import 'package:app_fleet/utils/utils.dart';

class WorkspaceEntity {
  late String name;
  late String iconPath;
  int defaultWorkspace; // Since v1.0.0+6
  Set<App> apps;

  WorkspaceEntity({
    required this.name,
    required this.iconPath,
    int? defaultWorkspace,
    Set<App>? applications,
  })  : apps = applications ?? {},
        defaultWorkspace = defaultWorkspace ?? -1;

  WorkspaceEntity.clone(
    WorkspaceEntity entity, {
    String? name,
    String? iconPath,
    int? defaultWorkspace,
    Set<App>? applications,
  })  : name = name ?? entity.name,
        iconPath = iconPath ?? entity.iconPath,
        defaultWorkspace = defaultWorkspace ?? entity.defaultWorkspace,
        apps = (applications != null ? {...applications} : {...entity.apps});

  Map<String, dynamic> toMap() {
    return {
      StorageKeys.nameKey: name,
      StorageKeys.iconPathKey: iconPath,
      StorageKeys.defaultWorkspaceKey: defaultWorkspace,
      StorageKeys.appsKey: apps.map((e) => e.toMap()).toList(),
    };
  }

  static final empty = WorkspaceEntity(
    name: '',
    iconPath: '',
    applications: {},
  );

  static WorkspaceEntity fromMap(Map<String, dynamic> data) {
    var dynamicApps = (data[StorageKeys.appsKey].map((e) => App.fromMap(e)));
    var apps = <App>{};
    for (var app in dynamicApps) {
      if (!apps.contains(app)) {
        apps.add(app);
      }
    }
    return WorkspaceEntity(
      name: data[StorageKeys.nameKey],
      iconPath: data[StorageKeys.iconPathKey],
      defaultWorkspace: data[StorageKeys.defaultWorkspaceKey],
      applications: apps.toSet(),
    );
  }

  @override
  bool operator ==(Object other) {
    if (other.runtimeType == WorkspaceEntity) {
      other = other as WorkspaceEntity;
      if (name == other.name &&
          iconPath == other.iconPath &&
          defaultWorkspace == other.defaultWorkspace) {
        if (apps.length != other.apps.length) {
          return false;
        }
        int numberOfIdenticalAppEntries = 0;
        for (var app in apps) {
          for (var otherApp in other.apps) {
            if (app == otherApp) {
              numberOfIdenticalAppEntries++;
            }
          }
        }
        return numberOfIdenticalAppEntries == apps.length;
      }
      return false;
    }
    return super == other;
  }

  @override
  int get hashCode =>
      super.hashCode ^
      name.hashCode ^
      iconPath.hashCode ^
      defaultWorkspace.hashCode ^
      apps.hashCode;
}

class App {
  String name;
  String iconPath;
  String exe;
  int waitTime;
  int priority;
  bool internallyGenerated;

  String get appIconPath => iconPath.isEmpty ? AppIcons.unknown : iconPath;

  App({
    required this.name,
    required this.iconPath,
    required this.exe,
    this.waitTime = 500,
    this.priority = 0,
    this.internallyGenerated = false,
  });

  App.clone(
    App app, {
    String? name,
    String? iconPath,
    String? exe,
    int? priority,
    int? waitTime,
    bool? internallyGenerated,
  })  : name = name ?? app.name,
        iconPath = iconPath ?? app.iconPath,
        exe = exe ?? app.exe,
        priority = priority ?? app.priority,
        internallyGenerated = internallyGenerated ?? app.internallyGenerated,
        waitTime = waitTime ?? app.waitTime;

  static final empty = App(
    name: '',
    iconPath: '',
    exe: '',
  );

  Future<void> launch() async {
    await Future.delayed(const Duration(
        milliseconds:
            200)); // this assures that workspace has been switched in the front-end
    await executeProcessExecutor(exe);
    await Future.delayed(Duration(milliseconds: waitTime));
  }

  Map<String, dynamic> toMap() {
    return {
      StorageKeys.nameKey: name,
      StorageKeys.iconPathKey: iconPath,
      StorageKeys.exeKey: exe,
      StorageKeys.waitTimeKey: waitTime,
      StorageKeys.priorityKey: priority,
      StorageKeys.internallyGeneratedKey: internallyGenerated,
    };
  }

  static App fromMap(Map<String, dynamic> data) {
    return App(
      name: data[StorageKeys.nameKey],
      iconPath: data[StorageKeys.iconPathKey],
      exe: data[StorageKeys.exeKey],
      waitTime: data[StorageKeys.waitTimeKey] != null
          ? int.parse(data[StorageKeys.waitTimeKey]!.toString())
          : 500,
      priority: data[StorageKeys.priorityKey] != null
          ? int.parse(data[StorageKeys.priorityKey]!.toString())
          : 0,
      internallyGenerated: data[StorageKeys.internallyGeneratedKey] ?? false,
    );
  }

  @override
  bool operator ==(Object other) {
    if (other.runtimeType == App) {
      final otherApp = other as App;
      return otherApp.name == name &&
          otherApp.iconPath == iconPath &&
          otherApp.exe == exe &&
          otherApp.waitTime == waitTime &&
          otherApp.internallyGenerated == internallyGenerated &&
          otherApp.priority == priority;
    }
    return super == other;
  }

  @override
  int get hashCode =>
      super.hashCode ^
      name.hashCode ^
      iconPath.hashCode ^
      exe.hashCode ^
      waitTime.hashCode ^
      internallyGenerated.hashCode ^
      priority.hashCode;
}
