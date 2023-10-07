import 'dart:io';

import 'package:app_fleet/app/config/domain/workspace_entity.dart';
import 'package:app_fleet/app/launcher/data/launcher_repository.dart';
import 'package:app_fleet/app/launcher/presentation/launcher_controller.dart';
import 'package:app_fleet/config/assets/app_icons.dart';
import 'package:app_fleet/config/theme/app_theme.dart';
import 'package:app_fleet/main.dart';
import 'package:app_fleet/utils/app_tooltip_builder.dart';
import 'package:app_fleet/utils/app_window_buttons.dart';
import 'package:app_fleet/utils/bottom_bar.dart';
import 'package:app_fleet/utils/utils.dart';
import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';

class LauncherInitializedStateView extends StatefulWidget {
  const LauncherInitializedStateView({
    super.key,
    required this.controller,
  });

  final LauncherController controller;

  @override
  State<LauncherInitializedStateView> createState() =>
      _LauncherInitializedStateViewState();
}

class _LauncherInitializedStateViewState
    extends State<LauncherInitializedStateView> {
  Set<WorkspaceEntity> workspaces = {};
  String? launchStatus;

  @override
  void initState() {
    super.initState();
    workspaces = widget.controller.getWorkspaces();
  }

  Image getWorkspaceIcon(icon) {
    final iconPath = icon;
    if (iconPath.startsWith('assets/icons/picker')) {
      return Image.asset(
        iconPath,
        width: 48,
      );
    }
    return Image.file(
      File(iconPath),
      width: 48,
    );
  }

  Iterable<Widget> _buildContent() sync* {
    for (var workspaceEntity in workspaces) {
      bool hover = false;
      yield StatefulBuilder(
        builder: (context, setContentState) {
          return GestureDetector(
            onTap: () {
              widget.controller.launch(
                workspaceEntity,
                onProgress: (status) {
                  if (status.startsWith(launchStartTag)) {
                    setState(() {
                      launchStatus =
                          status.substring(launchStartTag.length).trim();
                    });
                  } else if (status.startsWith(launchProgressTag)) {
                    setState(() {
                      launchStatus =
                          status.substring(launchProgressTag.length).trim();
                    });
                  } else {
                    setState(() {
                      launchStatus = null;
                    });
                  }
                },
              );
            },
            child: MouseRegion(
              onEnter: (e) => setContentState(() => hover = true),
              onExit: (e) => setContentState(() => hover = false),
              child: AppTooltipBuilder.wrap(
                text: workspaceEntity.name,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  width: 80,
                  height: 80,
                  padding: const EdgeInsets.all(16.0),
                  margin: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: accentColorMap[
                                workspaceEntity.name[0].toUpperCase()]!
                            .withOpacity(hover ? 0.6 : 0.2),
                        blurRadius: 16,
                      )
                    ],
                  ),
                  child: Center(
                    child: AnimatedScale(
                      duration: const Duration(milliseconds: 500),
                      scale: hover ? 0.8 : 1.0,
                      child: getWorkspaceIcon(
                        workspaceEntity.iconPath,
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
  }

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
                child: SizedBox(
                  width: 500,
                  height: 200,
                  child: Stack(
                    children: [
                      Align(
                        child: Container(
                          width: 500,
                          height: 200,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(30),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.blueGrey.withOpacity(0.4),
                                blurRadius: 16,
                              ),
                            ],
                          ),
                          child: Center(
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  ..._buildContent(),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.topLeft,
                        child: Padding(
                          padding: const EdgeInsets.all(10),
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
                                  icon: const Icon(
                                    Icons.refresh,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      if (launchStatus != null)
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Text(
                              launchStatus!,
                              style: AppTheme.fontSize(14).makeBold(),
                            ),
                          ),
                        ),
                      Align(
                        alignment: Alignment.topRight,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: appWindowButton(
                            color: Colors.red,
                            onPressed: () {
                              appWindow.close();
                              Navigator.pop(context);
                            },
                          ),
                        ),
                      ),
                    ],
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
