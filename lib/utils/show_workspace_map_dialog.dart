import 'package:app_fleet/app/config/domain/workspace_entity.dart';
import 'package:app_fleet/config/assets/app_icons.dart';
import 'package:app_fleet/config/theme/app_theme.dart';
import 'package:app_fleet/main.dart';
import 'package:app_fleet/utils/app_tooltip_builder.dart';
import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

List<Widget> _buildContent({
  required WorkspaceEntity workspaceEntity,
  required int priority,
  required int maxPriority,
  required VoidCallback onMapUpdate,
  required Map<int, List<App>> Function() getWorkspaceMapCallback,
}) {
  void deselect(App app) {
    app.priority = 0;
  }

  void select(App app) {
    app.priority = priority;
  }

  List<Widget> workspaces = [];

  for (final app in workspaceEntity.apps) {
    bool hover = false;
    workspaces.add(StatefulBuilder(
      builder: (context, setContentState) {
        return GestureDetector(
          onTap: () {
            setContentState(() {
              if (app.priority == priority) {
                var workspaceMap = getWorkspaceMapCallback();
                debugPrintApp("$priority $maxPriority");
                if (priority > 0 && priority < maxPriority) {
                  if (workspaceMap[priority]!.length == 1) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        behavior: SnackBarBehavior.floating,
                        margin: const EdgeInsets.symmetric(
                            horizontal: 200, vertical: 200),
                        backgroundColor: AppTheme.background,
                        elevation: 3,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                        content: Row(
                          children: [
                            const Icon(
                              Icons.info,
                              color: Colors.redAccent,
                            ),
                            const SizedBox(width: 10.0),
                            Text(
                              "Only #${maxPriority + 1} Workspace can be left empty",
                              style: AppTheme.fontSize(14),
                            ),
                          ],
                        ),
                      ),
                    );
                    return;
                  }
                }
                deselect(app);
              } else {
                select(app);
              }
              onMapUpdate();
            });
          },
          child: MouseRegion(
            onEnter: (e) => setContentState(() => hover = true),
            onExit: (e) => setContentState(() => hover = false),
            child: SizedBox(
              width: 70,
              height: 70,
              child: Stack(
                children: [
                  Align(
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 250),
                      width: 60,
                      height: 60,
                      margin: const EdgeInsets.symmetric(horizontal: 2.0),
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      decoration: BoxDecoration(
                        color: AppTheme.appTileForeground
                            .withOpacity(hover ? 0.4 : 1.0),
                        borderRadius: BorderRadius.circular(40),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: AppTooltipBuilder.wrap(
                          text: app.name,
                          child: app.iconPath.endsWith('.svg')
                              ? SvgPicture.asset(
                                  app.appIconPath,
                                  placeholderBuilder: (context) => Image.asset(
                                    AppIcons.unknown,
                                    width: 48,
                                  ),
                                )
                              : Image.asset(
                                  app.appIconPath,
                                  filterQuality: FilterQuality.high,
                                ),
                        ),
                      ),
                    ),
                  ),
                  if (app.priority == priority)
                    Align(
                      alignment: Alignment.topRight,
                      child: Container(
                        width: 20,
                        height: 20,
                        decoration: BoxDecoration(
                          color: AppTheme.selectedWorkspaceIndicatorBackground,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Icon(
                          Icons.done_rounded,
                          color: AppTheme.selectedWorkspaceIndicatorForeground,
                          size: 16,
                        ),
                      ),
                    ),
                  if (app.priority != priority)
                    Align(
                      alignment: Alignment.topRight,
                      child: Container(
                        width: 20,
                        height: 20,
                        decoration: BoxDecoration(
                          color:
                              AppTheme.unselectedWorkspaceIndicatorBackground,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Center(
                          child: Text(
                            "${app.priority + 1}",
                            style: AppTheme.fontSize(13).makeBold().withColor(
                                AppTheme
                                    .unselectedWorkspaceIndicatorForeground),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        );
      },
    ));
  }
  return workspaces;
}

void showWorkspaceMapDialog({
  required int priority,
  required int maxPriority,
  required WorkspaceEntity workspaceEntity,
  required BuildContext context,
  required VoidCallback onMapUpdate,
  required Map<int, List<App>> Function() getWorkspaceMapCallback,
}) {
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
            child: SizedBox(
              width: 435,
              height: 300,
              child: StatefulBuilder(builder: (context, setState) {
                return Stack(
                  children: [
                    Align(
                      child: Container(
                        width: 385,
                        height: 250,
                        decoration: BoxDecoration(
                          color: AppTheme.workspaceDialogBackground,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: AppTheme.workspaceDialogDropShadowColor,
                              blurRadius: 16,
                            )
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(
                            top: 16.0,
                            left: 16.0,
                          ),
                          child: SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Apps of #${priority + 1} Workspace${workspaceEntity.defaultWorkspace == priority ? "(Default)" : ""}",
                                  style: AppTheme.fontSize(16).makeBold(),
                                ),
                                const SizedBox(height: 10.0),
                                Wrap(
                                  runSpacing: 10.0,
                                  children: [
                                    ..._buildContent(
                                      workspaceEntity: workspaceEntity,
                                      priority: priority,
                                      maxPriority: maxPriority,
                                      onMapUpdate: onMapUpdate,
                                      getWorkspaceMapCallback:
                                          getWorkspaceMapCallback,
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.topRight,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          style: IconButton.styleFrom(
                            backgroundColor: Colors.red,
                          ),
                          icon: const Icon(
                            Icons.close,
                            color: Colors.white,
                          ),
                          iconSize: 20,
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.topLeft,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: AppTooltipBuilder.wrap(
                          text: "Mark as Default Workspace",
                          child: IconButton(
                            onPressed: () {
                              if (workspaceEntity.defaultWorkspace ==
                                  priority) {
                                workspaceEntity.defaultWorkspace = -1;
                              } else {
                                workspaceEntity.defaultWorkspace = priority;
                              }
                              setState(() {});
                            },
                            style: IconButton.styleFrom(
                              backgroundColor:
                                  workspaceEntity.defaultWorkspace == priority
                                      ? Colors.blueAccent
                                      : Colors.white,
                              side: workspaceEntity.defaultWorkspace == priority
                                  ? null
                                  : const BorderSide(
                                      color: Colors.blueAccent, width: 2),
                            ),
                            icon: Icon(
                              Icons.push_pin_outlined,
                              color:
                                  workspaceEntity.defaultWorkspace == priority
                                      ? Colors.white
                                      : Colors.blueAccent,
                            ),
                            iconSize: 20,
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              }),
            ),
          ),
        ),
      );
    },
  );
}
