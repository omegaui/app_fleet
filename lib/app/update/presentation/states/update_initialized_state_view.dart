import 'dart:async';
import 'dart:io';

import 'package:app_fleet/app/update/presentation/update_controller.dart';
import 'package:app_fleet/config/assets/app_animations.dart';
import 'package:app_fleet/config/theme/app_theme.dart';
import 'package:app_fleet/core/app_bug_report.dart';
import 'package:app_fleet/core/app_updater.dart';
import 'package:app_fleet/core/dependency_manager.dart';
import 'package:app_fleet/core/route_service.dart';
import 'package:app_fleet/utils/bottom_bar.dart';
import 'package:app_fleet/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class UpdateInitializedStateView extends StatefulWidget {
  const UpdateInitializedStateView({
    super.key,
    required this.controller,
    required this.updateData,
    required this.reinstall,
  });

  final UpdateController controller;
  final UpdateData updateData;
  final bool reinstall;

  @override
  State<UpdateInitializedStateView> createState() =>
      _UpdateInitializedStateViewState();
}

class _UpdateInitializedStateViewState
    extends State<UpdateInitializedStateView> {
  StreamSubscription? streamSubscription;

  String status = "Connecting to server ...";
  bool downloadButtonEnable = true;
  bool success = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(
      const Duration(seconds: 2),
      () async {
        widget.controller.invokeUpdater(
          data: widget.updateData,
          onProgress: (progress) {
            setState(() {
              status = "Downloading bundle $progress% ...";
            });
          },
          onComplete: (bytes) {
            setState(() {
              status = "Saving Bundle ...";
              final releasesDir = combineHomePath(
                [
                  ".config",
                  "app-fleet-releases",
                ],
              );
              mkdir(releasesDir, "Creating releases storage ...");
              mkdir(
                  combineHomePath(
                    [
                      ".config",
                      "app-fleet-releases",
                      widget.updateData.data,
                    ],
                  ),
                  "Creating release dir for ${widget.updateData.data}");
              final bundlePath = combineHomePath([
                ".config",
                "app-fleet-releases",
                widget.updateData.data,
                "app-fleet-${widget.updateData.data}.zip"
              ]);
              final bundleFile = File(bundlePath);
              bundleFile.writeAsBytesSync(bytes);
              status = "Extracting bundle ...";
              downloadButtonEnable = false;
              Future.delayed(
                const Duration(seconds: 1),
                () {
                  setState(() {
                    Process.runSync("unzip", [bundlePath],
                        workingDirectory: bundleFile.parent.path);
                    bundleFile.deleteSync();
                    Future.delayed(
                      const Duration(seconds: 2),
                      () {
                        setState(() {
                          status = "Starting Installer in your terminal ...";
                          Process.runSync(
                            'chmod',
                            [
                              '+x',
                              combineHomePath([
                                ".config",
                                "app-fleet-releases",
                                widget.updateData.data,
                                'install.sh',
                              ], absolute: true),
                              combineHomePath([
                                ".config",
                                "app-fleet-releases",
                                widget.updateData.data,
                                'update.sh',
                              ], absolute: true),
                              combineHomePath([
                                ".config",
                                "app-fleet-releases",
                                widget.updateData.data,
                                "integration"
                                    'integrate.sh',
                              ], absolute: true),
                            ],
                          );
                          Future.delayed(
                            const Duration(seconds: 2),
                            () {
                              setState(() {
                                status = "Installing ...";
                                Process.runSync(
                                  'gnome-terminal',
                                  [
                                    "--",
                                    combineHomePath([
                                      ".config",
                                      "app-fleet-releases",
                                      widget.updateData.data,
                                      widget.reinstall
                                          ? 'install.sh'
                                          : 'update.sh',
                                    ], absolute: true),
                                  ],
                                  workingDirectory: bundleFile.parent.path,
                                );
                                Future.delayed(
                                  const Duration(seconds: 2),
                                  () {
                                    setState(() {
                                      status =
                                          "Authorize in the installer terminal,\nand restart.";
                                      success = true;
                                    });
                                  },
                                );
                              });
                            },
                          );
                        });
                      },
                    );
                  });
                },
              );
            });
          },
          onError: (error) {
            setState(() {
              status = "An Error Occurred";
              AppBugReport.createReport(
                message: "Error Occurred when downloading App Bundle.",
                source: "Updater",
                additionalDescription: "Possibly network problem.",
                error: error,
                stackTrace: StackTrace.empty,
              );
            });
          },
          onStartFailure: () {
            setState(() {
              status = "Cannot connect to server";
            });
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          Align(
            child: Container(
              width: 400,
              height: 300,
              decoration: BoxDecoration(
                color: AppTheme.background,
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.windowDropShadow,
                    blurRadius: 16,
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Lottie.asset(
                    success ? AppAnimations.success : AppAnimations.updating,
                    width: 200,
                  ),
                  Text(
                    status,
                    textAlign: TextAlign.center,
                    style: AppTheme.fontSize(14).makeBold(),
                  ),
                  const SizedBox(height: 10),
                  if (downloadButtonEnable)
                    TextButton(
                      onPressed: () async {
                        if (streamSubscription != null) {
                          await streamSubscription!.cancel();
                          DependencyInjection.find<RouteService>()
                              .gotoRoute(RouteService.homeRoute);
                        }
                      },
                      style: TextButton.styleFrom(
                        backgroundColor: AppTheme.negativeOptionBackground,
                        foregroundColor: AppTheme.safeOptionForeground,
                      ),
                      child: Text(
                        "Cancel",
                        style: AppTheme.fontSize(14).makeBold(),
                      ),
                    ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 100.0),
            child: bottomBar(
              text: "App Fleet Updater",
            ),
          ),
        ],
      ),
    );
  }
}
