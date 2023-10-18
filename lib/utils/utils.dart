import 'dart:convert';
import 'dart:io';

import 'package:app_fleet/app/config/domain/workspace_entity.dart';
import 'package:app_fleet/core/app_bug_report.dart';
import 'package:app_fleet/main.dart';
import 'package:flutter/material.dart';

const jsonEncoder = JsonEncoder.withIndent('  ');

Map<String, Color> accentColorMap = {
  'A': Colors.redAccent,
  'B': Colors.blueAccent,
  'C': Colors.greenAccent,
  'D': Colors.purpleAccent,
  'E': Colors.orangeAccent,
  'F': Colors.pinkAccent,
  'G': Colors.tealAccent,
  'H': Colors.amberAccent,
  'I': Colors.indigoAccent,
  'J': Colors.cyanAccent,
  'K': Colors.lightBlueAccent,
  'L': Colors.lightGreenAccent,
  'M': Colors.deepOrangeAccent,
  'N': Colors.deepPurpleAccent,
  'O': Colors.blueGrey,
  'P': Colors.deepOrange,
  'Q': Colors.deepPurple,
  'R': Colors.indigo,
  'S': Colors.lime,
  'T': Colors.red,
  'U': Colors.teal,
  'V': Colors.purple,
  'W': Colors.amber,
  'X': Colors.cyan,
  'Y': Colors.brown,
  'Z': Colors.grey,
};

void executeWorkspaceSwitcher(int workspaceNumber) {
  try {
    Process.runSync(
      combinePath([
        '.config',
        'workspace-switcher.sh',
      ]),
      [workspaceNumber.toString()],
    );
  } catch (error, stackTrace) {
    debugPrintApp(
        "[WorkspaceSwitcher] Got an error when trying to switch to workspace number $workspaceNumber");
    AppBugReport.createReport(
      message:
          "Got an error when trying to switch to workspace number $workspaceNumber",
      source: "`utils.dart` - `executeWorkspaceSwitcher()`",
      additionalDescription: "The synchronous process failed abruptly.",
      error: error,
      stackTrace: stackTrace,
    );
  }
}

Future<void> executeProcessExecutor(String command) async {
  try {
    await Process.start(
      combinePath([
        ".config",
        'unix-process-executor.sh',
      ]),
      [command],
    );
  } catch (error, stackTrace) {
    debugPrintApp(
        "[ProcessExecutor] Got an error when trying to run command: \"$command\"");
    AppBugReport.createReport(
      message: "Got an error when trying to run command: \"$command\"",
      source: "`utils.dart` - `executeProcessExecutor()`",
      additionalDescription:
          "The asynchronous process failed to launch the app's execution point.",
      error: error,
      stackTrace: stackTrace,
    );
  }
}

String getSystemTheme() {
  try {
    final result = Process.runSync(
      combinePath([
        '.config',
        'theme-detector.sh',
      ]),
      [],
    );
    int exitCode = result.exitCode;
    return exitCode == 1 ? 'dark' : 'light';
  } on Exception {
    debugPrintApp(
        "[WorkspaceSwitcher] Got an error when trying to identify System Theme");
  }
  // falling back to light if any error occurs
  return 'light';
}

String combinePath(List<String> locations, {bool absolute = false}) {
  String path = locations.join(Platform.pathSeparator);
  return absolute ? File(path).absolute.path : path;
}

void mkdir(String path, String logMessage) {
  var dir = Directory(path);
  if (!dir.existsSync()) {
    dir.createSync();
  }
}

String toWorkspaceStorageName(WorkspaceEntity entity) {
  return "${entity.name}.json";
}

String fromWorkspaceStorageName(String name) {
  return name.substring(0, name.lastIndexOf(".json"));
}

bool containsIgnoreCase(String mainString, String subString) {
  final mainLower = mainString.toLowerCase();
  final subLower = subString.toLowerCase();
  return mainLower.contains(subLower);
}

void switchWorkspace(int number) {
  Process.runSync(
      'gsettings', ['get', 'org.gnome.desktop.interface', 'icon-theme']);
}

String getBugReportPath(String reportID) {
  return "file://${Platform.environment['HOME']}/app-fleet/.config/bug-reports/$reportID.md";
}

String getWorkspacePath(String workspaceName) {
  return "file://${Platform.environment['HOME']}/app-fleet/.config/workspaces/$workspaceName.json";
}

bool launcherModeCapable() {
  return debugMode ||
      File('${Platform.environment['HOME']}/app-fleet/.config/app-settings.json')
          .existsSync();
}

String getAccentChar(String name) {
  var result = name[0];
  String? maxOccurredChar;
  int lastWeight = 0;
  for (var char in name.characters) {
    int weight = 0;
    for (var charX in name.characters) {
      if (charX == char) {
        weight++;
      }
    }
    if (weight > lastWeight) {
      lastWeight = weight;
      maxOccurredChar = char;
    }
  }
  return maxOccurredChar ?? result;
}
