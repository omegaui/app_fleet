import 'dart:io';

import 'package:app_fleet/core/app_configuration.dart';
import 'package:app_fleet/core/dependency_manager.dart';
import 'package:app_fleet/main.dart';
import 'package:app_fleet/utils/utils.dart';
import 'package:http/http.dart';

class SettingsRepository {
  final storage = DependencyInjection.find<AppConfiguration>();

  String getThemeMode() {
    return storage.get('theme-mode') ?? 'light';
  }

  bool isAutostartEnabled() {
    return storage.get('autostart') ??
        File(combinePath([
          Platform.environment['HOME']!,
          '.config',
          'autostart',
          'app-fleet-launcher.desktop'
        ], absolute: true))
            .existsSync();
  }

  Future<void> setAutostartEnabled(bool value) async {
    final oldValue = isAutostartEnabled();
    if (oldValue == value) {
      return;
    }

    final autostartDesktopEntryFile = File(combinePath([
      Platform.environment['HOME']!,
      '.config',
      'autostart',
      'app-fleet-launcher.desktop'
    ], absolute: true));

    final autostartDesktopEntryBakFile = File(combinePath([
      Platform.environment['HOME']!,
      '.config',
      'autostart',
      'app-fleet-launcher.desktop.bak'
    ], absolute: true));

    if (value) {
      if (autostartDesktopEntryFile.existsSync()) {
        return;
      }
      if (autostartDesktopEntryBakFile.existsSync()) {
        autostartDesktopEntryBakFile.renameSync(autostartDesktopEntryFile.path);
      } else {
        try {
          debugPrintApp(
              '[SettingsUpdater] Downloading the latest autostart desktop entry ...');
          final response = await get(Uri.parse(
              'https://raw.githubusercontent.com/omegaui/app_fleet/main/package/integration/desktop-entries/app-fleet-launcher.desktop'));
          final contents = response.body;
          autostartDesktopEntryFile.writeAsStringSync(contents, flush: true);
        } on Exception {
          debugPrintApp(
              '[SettingsUpdater] Cannot download the latest autostart desktop entry.');
        }
      }
    } else {
      if (!autostartDesktopEntryFile.existsSync()) {
        return;
      }
      autostartDesktopEntryFile.renameSync(autostartDesktopEntryBakFile.path);
    }
    storage.put('autostart', value);
  }

  void setNotifyAboutUpdates(bool value) {
    storage.put('notify-updates', value);
  }

  bool notifyAboutUpdates() {
    return storage.get('notify-updates') ?? true;
  }
}
