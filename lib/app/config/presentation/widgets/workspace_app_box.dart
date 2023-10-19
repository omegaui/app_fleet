import 'package:app_fleet/app/config/domain/workspace_entity.dart';
import 'package:app_fleet/config/assets/app_icons.dart';
import 'package:app_fleet/config/theme/app_theme.dart';
import 'package:app_fleet/utils/app_tooltip_builder.dart';
import 'package:app_fleet/utils/show_app_dialog.dart';
import 'package:app_fleet/utils/show_app_selection_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_svg/flutter_svg.dart';

class WorkspaceAppBox extends StatefulWidget {
  const WorkspaceAppBox({
    super.key,
    required this.workspaceEntity,
    required this.onRebuildRequested,
  });

  final WorkspaceEntity workspaceEntity;
  final VoidCallback onRebuildRequested;

  @override
  State<WorkspaceAppBox> createState() => _WorkspaceAppBoxState();
}

class _WorkspaceAppBoxState extends State<WorkspaceAppBox> {
  List<Widget> _buildContent() {
    return widget.workspaceEntity.apps.map(
      (app) {
        int count = widget.workspaceEntity.apps.toList().indexOf(app);
        bool hover = false;
        return GestureDetector(
          onTap: () {
            showAppDialog(
              app: app,
              context: context,
              onClose: (App? updatedApp) {
                setState(
                  () {
                    if (updatedApp != null) {
                      widget.workspaceEntity.apps.remove(app);
                      widget.workspaceEntity.apps.add(updatedApp);
                      widget.onRebuildRequested();
                    }
                  },
                );
              },
            );
          },
          onSecondaryTap: () {
            setState(() {
              widget.workspaceEntity.apps.remove(app);
              widget.onRebuildRequested();
            });
          },
          child: StatefulBuilder(
            builder: (context, setState) {
              return MouseRegion(
                onEnter: (e) => setState(() => hover = true),
                onExit: (e) => setState(() => hover = false),
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
                            color: AppTheme.configLabelBackground
                                .withOpacity(hover ? 0.4 : 0.2),
                            borderRadius: BorderRadius.circular(40),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: AppTooltipBuilder.wrap(
                              text: app.name,
                              child: app.iconPath.endsWith('.svg')
                                  ? SvgPicture.asset(
                                      app.appIconPath,
                                      placeholderBuilder: (context) =>
                                          Image.asset(
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
                        ).animate().scale(
                            delay: Duration(milliseconds: 500 + (count * 100)),
                            duration: const Duration(milliseconds: 400)),
                      ),
                      Align(
                        alignment: Alignment.topRight,
                        child: Container(
                          width: 20,
                          height: 20,
                          decoration: BoxDecoration(
                            color: AppTheme.appWorkspaceIndicatorBackground,
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Center(
                            child: Text(
                              "${app.priority + 1}",
                              style: AppTheme.fontSize(13).makeBold().withColor(
                                  AppTheme.appWorkspaceIndicatorForeground),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    ).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 30.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: AppTheme.configLabelBackground,
                  borderRadius: BorderRadius.circular(30),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 3.0),
                child: Text(
                  "Workspace Apps",
                  style: AppTheme.fontSize(16)
                      .makeBold()
                      .withColor(AppTheme.configLabelForeground),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: IconButton(
                  onPressed: () {
                    showAppDialog(
                      app: App.clone(App.empty),
                      context: context,
                      onClose: (App? app) {
                        setState(() {
                          if (app != null) {
                            widget.workspaceEntity.apps.add(app);
                            widget.onRebuildRequested();
                          }
                        });
                      },
                    );
                  },
                  style: IconButton.styleFrom(
                    backgroundColor: AppTheme.addAppButtonBackground,
                  ),
                  icon: Icon(
                    Icons.add,
                    color: AppTheme.addAppButtonForeground,
                  ),
                ),
              ),
              AppTooltipBuilder.wrap(
                text: "Pick an app from your system (Ctrl + F)",
                child: IconButton(
                  onPressed: () {
                    showAppSelectionDialog(
                      context: context,
                      onClick: (app) {
                        setState(
                          () {
                            if (app != null) {
                              widget.workspaceEntity.apps.remove(app);
                              widget.workspaceEntity.apps.add(app);
                              widget.onRebuildRequested();
                            }
                          },
                        );
                      },
                    );
                  },
                  style: IconButton.styleFrom(
                    backgroundColor: AppTheme.selectAppButtonBackground,
                  ),
                  icon: Icon(
                    Icons.my_location,
                    color: AppTheme.selectAppButtonForeground,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: AppTooltipBuilder.wrap(
                  text: "Remove All",
                  child: IconButton(
                    onPressed: () {
                      setState(() {
                        widget.workspaceEntity.apps.clear();
                        widget.onRebuildRequested();
                      });
                    },
                    style: IconButton.styleFrom(
                      backgroundColor: AppTheme.removeAppsButtonBackground,
                    ),
                    icon: Icon(
                      Icons.playlist_remove_rounded,
                      color: AppTheme.removeAppsButtonForeground,
                    ),
                  ),
                ),
              ),
            ],
          ),
          Wrap(
            runSpacing: 5.0,
            children: [
              ..._buildContent(),
            ],
          ),
        ],
      ),
    );
  }
}
