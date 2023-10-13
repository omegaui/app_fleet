import 'dart:convert';
import 'dart:io';

import 'package:app_fleet/core/app_bug_report.dart';
import 'package:app_fleet/main.dart';
import 'package:app_fleet/utils/utils.dart';

class JsonConfigurator {
  final String configName;
  late String configPath;
  dynamic config;

  JsonConfigurator({
    required this.configName,
    this.config,
  }) {
    configPath = combinePath([".config", configName]);
    _load();
  }

  void _load() {
    config = jsonDecode("{}");
    try {
      File file = File(configPath);
      if (file.existsSync()) {
        config = jsonDecode(file.readAsStringSync());
      } else {
        // Creating raw session config
        file.createSync();
        file.writeAsStringSync("{}", flush: true);
        onNewCreation();
      }
    } catch (error, stackTrace) {
      debugPrintApp(
          "Permission Denied when Creating Configuration: $configName, cannot continue!");
      AppBugReport.createReport(
        message: "Unable to write configuration file: $configPath",
        source: "`JsonConfigurator` - `_load()`",
        additionalDescription:
            "Possible Reason could be a non-existing parent directory.",
        error: error,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }

  void onNewCreation() {
    // called when the config file is auto created!
  }

  void reload() {
    _load();
  }

  void overwriteAndReload(String content) {
    File file = File(configPath);
    if (!file.existsSync()) {
      file.createSync();
    }
    file.writeAsStringSync(content, flush: true);
    _load();
  }

  void put(key, value) {
    config[key] = value;
    save();
  }

  void add(key, value) {
    debugPrintApp("[JsonConfigurator] Added $value to $key");
    var list = config[key];
    if (list != null) {
      config[key] = {...list, value}.toList();
    } else {
      config[key] = [value];
    }
    save();
  }

  void remove(key, value) {
    var list = config[key];
    if (list != null) {
      list.remove(value);
      config[key] = list;
    } else {
      config[key] = [];
    }
    save();
  }

  dynamic get(key) {
    return config[key];
  }

  void save() {
    try {
      File(configPath).writeAsStringSync(jsonEncode(config), flush: true);
    } catch (error, stackTrace) {
      debugPrintApp("Permission Denied when Saving Configuration: $configName");
      AppBugReport.createReport(
        message: "Unable to save configuration file: $configPath",
        source: "`JsonConfigurator` - `save()`",
        additionalDescription:
            "Possible Reason could be a non-existing parent directory or Permission Denied by the operating system.",
        error: error,
        stackTrace: stackTrace,
      );
    }
  }
}
