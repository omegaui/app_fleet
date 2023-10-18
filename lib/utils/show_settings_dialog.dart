import 'package:app_fleet/app/settings/data/settings_repository.dart';
import 'package:app_fleet/config/theme/app_theme.dart';
import 'package:app_fleet/core/app_session.dart';
import 'package:app_fleet/core/dependency_manager.dart';
import 'package:app_fleet/utils/app_tooltip_builder.dart';
import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';

void showSettingsDialog(BuildContext context) {
  final settingsRepo = DependencyInjection.find<SettingsRepository>();
  final appSession = DependencyInjection.find<AppSession>();
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
            child: StatefulBuilder(builder: (context, setModalState) {
              return FittedBox(
                child: Container(
                  width: 400,
                  height: 300,
                  decoration: BoxDecoration(
                    color: AppTheme.background,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: AppTheme.dialogDropShadow,
                        blurRadius: 16,
                      ),
                    ],
                  ),
                  child: Stack(
                    children: [
                      Align(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20.0, vertical: 20.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    "Preferences",
                                    style: AppTheme.fontSize(18).makeBold(),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    "Show Launcher Window on Startup",
                                    style: AppTheme.fontSize(14),
                                  ),
                                  const SizedBox(width: 20),
                                  Switch(
                                    value: settingsRepo.isAutostartEnabled(),
                                    activeColor: AppTheme.switchColor,
                                    onChanged: (value) async {
                                      await settingsRepo
                                          .setAutostartEnabled(value);
                                      setModalState(() {});
                                    },
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    "Notify me when an update arrives ",
                                    style: AppTheme.fontSize(14),
                                  ),
                                  const SizedBox(width: 20),
                                  Switch(
                                    value: settingsRepo.notifyAboutUpdates(),
                                    activeColor: AppTheme.switchColor,
                                    onChanged: (value) async {
                                      settingsRepo.setNotifyAboutUpdates(value);
                                      setModalState(() {});
                                    },
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    "Always Keep Launcher Alive       ",
                                    style: AppTheme.fontSize(14),
                                  ),
                                  const SizedBox(width: 20),
                                  Switch(
                                    value: settingsRepo.getKeepAliveLauncher(),
                                    activeColor: AppTheme.switchColor,
                                    onChanged: (value) async {
                                      settingsRepo.setKeepAliveLauncher(value);
                                      setModalState(() {});
                                    },
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    "Choose your theme",
                                    style: AppTheme.fontSize(15),
                                  ),
                                  const SizedBox(width: 20),
                                  DropdownButton<String>(
                                    value: settingsRepo.getThemeMode(),
                                    dropdownColor: AppTheme.background,
                                    focusColor: AppTheme.fieldFocusedColor,
                                    items: [
                                      DropdownMenuItem<String>(
                                        value: 'system',
                                        child: Text(
                                          'System',
                                          style:
                                              AppTheme.fontSize(14).makeBold(),
                                        ),
                                      ),
                                      DropdownMenuItem<String>(
                                        value: 'light',
                                        child: Text(
                                          'Light',
                                          style:
                                              AppTheme.fontSize(14).makeBold(),
                                        ),
                                      ),
                                      DropdownMenuItem<String>(
                                        value: 'dark',
                                        child: Text(
                                          'Dark',
                                          style:
                                              AppTheme.fontSize(14).makeBold(),
                                        ),
                                      ),
                                    ],
                                    onChanged: (value) {
                                      final previousTheme =
                                          settingsRepo.getThemeMode();
                                      if (previousTheme ==
                                          (value ?? 'system')) {
                                        return;
                                      }
                                      setModalState(() {
                                        settingsRepo
                                            .setThemeMode(value ?? 'system');
                                        appSession.reloadTheme();
                                      });
                                    },
                                  ),
                                  const SizedBox(width: 10),
                                  AppTooltipBuilder.wrap(
                                    text: "Refresh App",
                                    child: IconButton(
                                      onPressed: () {
                                        setModalState(() {
                                          appSession.reloadTheme();
                                        });
                                      },
                                      icon: Icon(
                                        Icons.refresh,
                                        color: AppTheme.foreground,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.topRight,
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: IconButton(
                            icon: Icon(
                              Icons.close,
                              color: Colors.grey.shade800,
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
        ),
      );
    },
  );
}
