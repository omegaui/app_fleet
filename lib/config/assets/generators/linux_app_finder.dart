import 'dart:io';

import 'package:app_fleet/app/config/domain/workspace_entity.dart';
import 'package:app_fleet/main.dart';

class LinuxAppFinder {
  static Set<App> apps = {};
  static Set<String> iconPaths = {};
  bool initialized = false;
  String? systemIconTheme;

  void initialize() {
    if (initialized) {
      debugPrintApp("[LinuxAppFinder] Already initialized ...");
      return;
    }
    debugPrintApp("[LinuxAppFinder] Caching Icon Paths ...");
    _cacheIcons();

    systemIconTheme = getSystemIconThemeSync();
    if (systemIconTheme != null) {
      debugPrintApp("[LinuxAppFinder] Your Icon Theme is $systemIconTheme");
    }

    debugPrintApp("[LinuxAppFinder] Loading Apps ...");

    _addAppsFrom('/usr/share/applications');
    _addAppsFrom(
        '/var/lib/snapd/desktop/applications'); // if system has snaps installed
    _addAppsFrom('${Platform.environment['HOME']}/.local/share/applications');

    debugPrintApp("[LinuxAppFinder] Loading Apps ... Done!");

    debugPrintApp(
        "[LinuxAppFinder] I have access to ${iconPaths.length} icon files on this system.");
    initialized = true;
  }

  void _cacheIcons() {
    _cacheFrom('/usr/share/icons');
    _cacheFrom('${Platform.environment['HOME']}/.local/share/icons');
  }

  void _cacheFrom(String path) {
    Directory iconThemesDir = Directory(path);
    var themes = iconThemesDir.listSync();
    for (var theme in themes) {
      if (theme.statSync().type == FileSystemEntityType.directory) {
        _loadIconsFromIconThemes(theme.path);
      }
    }
  }

  void _addAppsFrom(String path) {
    Directory systemApplicationsDir = Directory(path);
    var entries = systemApplicationsDir.listSync();
    for (var entity in entries) {
      if (entity.statSync().type == FileSystemEntityType.file) {
        _parseDesktopEntry(File(entity.path).readAsStringSync());
      }
    }
  }

  void _parseDesktopEntry(String contents) {
    if (!isAppEntry(contents)) {
      return;
    }
    List<String> lines = contents.split('\n');
    String name =
        lines.where((line) => line.startsWith('Name=')).first.substring(5);
    String icon =
        lines.where((line) => line.startsWith('Icon=')).first.substring(5);
    String exe =
        lines.where((line) => line.startsWith('Exec=')).first.substring(5);
    // completing icon path if incomplete
    bool found = icon.contains('/');
    bool foundInPixmaps = false;
    if (!found) {
      Directory pixmapsDir = Directory('/usr/share/pixmaps');
      var icons = pixmapsDir.listSync();
      for (var entity in icons) {
        if (entity.path.contains("/$icon.")) {
          icon = entity.path;
          foundInPixmaps = true;
          break;
        }
      }
    }
    if (!foundInPixmaps) {
      String? inferredIcon = _searchIconsFromIconThemes(icon);
      if (inferredIcon != null) {
        icon = inferredIcon;
      }
    }
    if (File(icon).existsSync()) {
      if (checkImageValidity(icon)) {
        apps.add(App(
          name: name,
          iconPath: icon,
          exe: exe,
          internallyGenerated: true,
        ));
      }
    }
  }

  String? _searchIconsFromIconThemes(String iconName) {
    String? lastIdentifiedPath;
    for (var path in iconPaths) {
      if (path.contains('$iconName.')) {
        lastIdentifiedPath = path;
        if (systemIconTheme != null) {
          if (path.contains('/$systemIconTheme/')) {
            break;
          }
        } else {
          break;
        }
      }
    }
    return lastIdentifiedPath;
  }

  void _loadIconsFromIconThemes(String themesDirPath) {
    _loadIconsOfSize(themesDirPath, "48x48");
    _loadIconsOfSize(themesDirPath, "64x64");
    _loadIconsOfSize(themesDirPath, "72x72");
    _loadIconsOfSize(themesDirPath, "96x96");
    _loadIconsOfSize(themesDirPath, "128x128");
    _loadIconsOfSize(themesDirPath, "192x192");
    _loadIconsOfSize(themesDirPath, "256x256");
    _loadIconsOfSize(themesDirPath, "512x512");
    _loadIconsOfSize(themesDirPath, "scalable");
  }

  void _loadIconsOfSize(String themesDirPath, String size) {
    var appDir = Directory("$themesDirPath/$size/apps");
    if (appDir.existsSync()) {
      var icons = appDir.listSync();
      for (var icon in icons) {
        iconPaths.add(icon.path);
      }
    }
  }

  bool isAppEntry(String contents) {
    return contents.contains("Name=") &&
        contents.contains("Icon=") &&
        contents.contains("Exec=");
  }

  bool checkImageValidity(path) {
    return !path.endsWith(".xpm");
  }

  String? getSystemIconThemeSync() {
    final result = Process.runSync(
        'gsettings', ['get', 'org.gnome.desktop.interface', 'icon-theme']);
    if (result.exitCode == 0) {
      var theme = (result.stdout as String).trim();
      return theme.substring(1, theme.length - 1);
    } else {
      return null;
    }
  }
}
