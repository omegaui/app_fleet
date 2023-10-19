import 'dart:io';

import 'package:app_fleet/app/config/domain/workspace_entity.dart';
import 'package:app_fleet/app/launcher/data/launcher_repository.dart';
import 'package:app_fleet/app/launcher/presentation/launcher_controller.dart';
import 'package:app_fleet/app/settings/data/settings_repository.dart';
import 'package:app_fleet/config/assets/app_icons.dart';
import 'package:app_fleet/config/theme/app_theme.dart';
import 'package:app_fleet/core/dependency_manager.dart';
import 'package:app_fleet/main.dart';
import 'package:app_fleet/utils/app_tooltip_builder.dart';
import 'package:app_fleet/utils/app_window_buttons.dart';
import 'package:app_fleet/utils/bottom_bar.dart';
import 'package:app_fleet/utils/utils.dart';
import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
  bool launchStarted = false;

  final settingsRepo = DependencyInjection.find<SettingsRepository>();

  @override
  void initState() {
    super.initState();
    onUpdate();
  }

  @override
  void didUpdateWidget(covariant LauncherInitializedStateView oldWidget) {
    super.didUpdateWidget(oldWidget);
    onUpdate();
  }

  void onUpdate() {
    workspaces = widget.controller.getWorkspaces(reload: false);
    final defaultWorkspaceName = settingsRepo.getDefaultWorkspace();
    if (defaultWorkspaceName != null) {
      for (final workspace in workspaces) {
        if (workspace.name == defaultWorkspaceName) {
          launchWorkspace(workspace);
          break;
        }
      }
    }
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

  void launchWorkspace(WorkspaceEntity workspaceEntity) {
    if (launchStarted) {
      return;
    }
    launchStarted = true;
    widget.controller.launch(
      workspaceEntity,
      onProgress: (status) {
        if (status.startsWith(launchStartTag)) {
          setState(() {
            launchStatus = status.substring(launchStartTag.length).trim();
          });
        } else if (status.startsWith(launchProgressTag)) {
          setState(() {
            launchStatus = status.substring(launchProgressTag.length).trim();
          });
        } else {
          setState(() {
            launchStatus = null;
          });
        }
      },
    );
  }

  Iterable<Widget> _buildContent() sync* {
    for (var workspaceEntity in workspaces) {
      bool hover = false;
      yield StatefulBuilder(
        builder: (context, setContentState) {
          return GestureDetector(
            onTap: () {
              launchWorkspace(workspaceEntity);
            },
            child: MouseRegion(
              onEnter: (e) => setContentState(() => hover = true),
              onExit: (e) => setContentState(() => hover = false),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    width: 80,
                    height: 80,
                    padding: const EdgeInsets.all(16.0),
                    margin: EdgeInsets.only(
                      top: 16.0,
                      bottom: hover ? 6.0 : 16.0,
                      right: 16.0,
                      left: 16.0,
                    ),
                    decoration: BoxDecoration(
                      color: AppTheme.background,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: (AppTheme.isDarkMode()
                                  ? AppTheme.dialogDropShadow
                                  : accentColorMap[
                                      getAccentChar(workspaceEntity.name)
                                          .toUpperCase()]!)
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
                  Text(
                    workspaceEntity.name,
                    style: AppTheme.fontSize(12).makeBold(),
                  ),
                ],
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
                            color: AppTheme.background,
                            borderRadius: BorderRadius.circular(30),
                            boxShadow: [
                              BoxShadow(
                                color: AppTheme.windowDropShadow,
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
                      if (launchStatus != null)
                        Align(
                          alignment: Alignment.topCenter,
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: SizedBox(
                              width: 300,
                              child: Text(
                                launchStatus!,
                                textAlign: TextAlign.center,
                                overflow: TextOverflow.ellipsis,
                                style: AppTheme.fontSize(13),
                              ),
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
                              SystemNavigator.pop();
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
