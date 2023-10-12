import 'package:app_fleet/app/settings/data/settings_repository.dart';
import 'package:app_fleet/config/theme/app_theme.dart';
import 'package:app_fleet/core/dependency_manager.dart';
import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';

void showSettingsDialog(BuildContext context) {
  final settingsRepo = DependencyInjection.find<SettingsRepository>();
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
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.4),
                        blurRadius: 16,
                      )
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
                              const SizedBox(height: 20),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    "Show Launcher Window on Startup",
                                    style: AppTheme.fontSize(15),
                                  ),
                                  const SizedBox(width: 20),
                                  Switch(
                                    value: settingsRepo.isAutostartEnabled(),
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
                                    style: AppTheme.fontSize(15),
                                  ),
                                  const SizedBox(width: 20),
                                  Switch(
                                    value: settingsRepo.notifyAboutUpdates(),
                                    onChanged: (value) async {
                                      settingsRepo.setNotifyAboutUpdates(value);
                                      setModalState(() {});
                                    },
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
