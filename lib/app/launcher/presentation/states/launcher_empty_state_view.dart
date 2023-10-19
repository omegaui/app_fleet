import 'package:app_fleet/app/launcher/presentation/launcher_controller.dart';
import 'package:app_fleet/config/assets/app_animations.dart';
import 'package:app_fleet/config/assets/app_icons.dart';
import 'package:app_fleet/config/theme/app_theme.dart';
import 'package:app_fleet/main.dart';
import 'package:app_fleet/utils/app_tooltip_builder.dart';
import 'package:app_fleet/utils/app_window_buttons.dart';
import 'package:app_fleet/utils/bottom_bar.dart';
import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';

class LauncherEmptyStateView extends StatefulWidget {
  const LauncherEmptyStateView({
    super.key,
    required this.controller,
  });

  final LauncherController controller;

  @override
  State<LauncherEmptyStateView> createState() => _LauncherEmptyStateViewState();
}

class _LauncherEmptyStateViewState extends State<LauncherEmptyStateView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Center(
        child: SizedBox.fromSize(
          size: windowSize,
          child: Stack(
            children: [
              Align(
                child: Container(
                  width: 500,
                  height: 200,
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
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 125,
                          child: Lottie.asset(
                            AppAnimations.loop,
                            fit: BoxFit.fitHeight,
                          ),
                        ),
                        Text(
                          "Once you create a workspace, you can launch it from here",
                          style: AppTheme.fontSize(13).makeBold(),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 30.0,
                    vertical: 60.0,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      AppTooltipBuilder.wrap(
                        text: "Open Workspace Manager",
                        child: IconButton(
                          onPressed: () {
                            widget.controller.launchWorkspaceManager();
                          },
                          icon: Image.asset(
                            AppIcons.appFleet,
                            width: 22,
                          ),
                        ),
                      ),
                      AppTooltipBuilder.wrap(
                        text: "Reload from Disk",
                        child: IconButton(
                          onPressed: () {
                            widget.controller.reloadFromDisk();
                          },
                          icon: Icon(
                            Icons.refresh,
                            color: AppTheme.foreground,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Align(
                alignment: Alignment.topRight,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 30.0,
                    vertical: 67.0,
                  ),
                  child: appWindowButton(
                    color: Colors.red,
                    onPressed: () {
                      appWindow.close();
                      SystemNavigator.pop();
                      Navigator.pop(context);
                    },
                  ),
                ),
              ),
              bottomBar(
                text: "App Fleet",
              ),
            ],
          ),
        ),
      ),
    );
  }
}
