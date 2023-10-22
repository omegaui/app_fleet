import 'dart:io';

import 'package:app_fleet/config/theme/app_theme.dart';
import 'package:app_fleet/utils/utils.dart';
import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppStorageManager {
  AppStorageManager._();

  static bool _eventsScriptsChecked = false;

  static bool get storageReady => _eventsScriptsChecked;

  static Future<void> initSpace() async {
    mkdir(combineHomePath([".config", "app-fleet"]), "Initializing App Settings Storage ...");
    mkdir(combineHomePath([".config", "app-fleet", "workspaces"]),
        "Initializing Workspace Storage ...");
    mkdir(combineHomePath([".config", "app-fleet", "themes"]), "Initializing Theme Storage ...");
    mkdir(combineHomePath([".config", "app-fleet", "bug-reports"]),
        "Initializing Bug Reports Storage ...");
    await checkThemes();
  }

  static Future<void> checkThemes() async {
    final lightTheme = File(combineHomePath([
      ".config", "app-fleet",
      "themes",
      'light.json',
    ]));
    final darkTheme = File(combineHomePath([
      ".config", "app-fleet",
      "themes",
      'dark.json',
    ]));
    if (!lightTheme.existsSync()) {
      lightTheme.writeAsStringSync(
        await rootBundle.loadString('assets/themes/light.json'),
        flush: true,
      );
    }
    if (!darkTheme.existsSync()) {
      darkTheme.writeAsStringSync(
        await rootBundle.loadString('assets/themes/dark.json'),
        flush: true,
      );
    }
  }

  static void checkScripts({required BuildContext context}) async {
    var path = combineHomePath([
      ".config", "app-fleet",
      'workspace-switcher.sh',
    ]);
    var workspaceSwitcher = File(path);
    if (!workspaceSwitcher.existsSync()) {
      workspaceSwitcher.writeAsStringSync(
          await rootBundle.loadString('assets/scripts/workspace-switcher.sh'),
          flush: true);
      // writing process executor for launching apps
      File(combineHomePath([
        ".config", "app-fleet",
        'unix-process-executor.sh',
      ])).writeAsStringSync(
        await rootBundle.loadString('assets/scripts/unix-process-executor.sh'),
        flush: true,
      );
      // writing theme detector
      File(combineHomePath([
        ".config", "app-fleet",
        'theme-detector.sh',
      ])).writeAsStringSync(
        await rootBundle.loadString('assets/scripts/theme-detector.sh'),
        flush: true,
      );
      Future.delayed(
        const Duration(seconds: 2),
        () async {
          await Process.run(
            'pkexec',
            [
              'chmod',
              '0755',
              combineHomePath([
                ".config", "app-fleet",
                'workspace-switcher.sh',
              ], absolute: true),
              combineHomePath([
                ".config", "app-fleet",
                'unix-process-executor.sh',
              ], absolute: true),
              combineHomePath([
                ".config", "app-fleet",
                'theme-detector.sh',
              ], absolute: true),
            ],
          );
          await Future.delayed(const Duration(seconds: 2));
          void closeEventScriptsDialog() {
            Navigator.pop(context);
            _eventsScriptsChecked = true;
          }

          closeEventScriptsDialog();
        },
      );
      void showEventScriptsDialog() {
        showDialog(
          context: context,
          barrierColor: Colors.transparent,
          builder: (context) {
            return Scaffold(
              backgroundColor: Colors.transparent,
              body: MoveWindow(
                onDoubleTap: () {
                  // this will prevent maximize operation
                },
                child: Align(
                  child: FittedBox(
                    child: Container(
                      width: 250,
                      height: 175,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.4),
                            blurRadius: 16,
                          )
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Making Event Scripts Executable\n(please authorize)",
                              textAlign: TextAlign.center,
                              style: AppTheme.fontSize(14).makeBold(),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            const CircularProgressIndicator(
                              color: Colors.pinkAccent,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        );
      }

      showEventScriptsDialog();
    } else {
      _eventsScriptsChecked = true;
    }
  }
}
