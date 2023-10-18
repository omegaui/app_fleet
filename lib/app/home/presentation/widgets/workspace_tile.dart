import 'dart:io';

import 'package:app_fleet/app/config/domain/workspace_entity.dart';
import 'package:app_fleet/config/assets/app_icons.dart';
import 'package:app_fleet/config/theme/app_theme.dart';
import 'package:app_fleet/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_svg/flutter_svg.dart';

class WorkspaceTile extends StatefulWidget {
  const WorkspaceTile({
    super.key,
    required this.workspaceEntity,
    required this.isDefaultWorkspace,
  });

  final WorkspaceEntity workspaceEntity;
  final bool isDefaultWorkspace;

  @override
  State<WorkspaceTile> createState() => _WorkspaceTileState();
}

class _WorkspaceTileState extends State<WorkspaceTile> {
  bool hover = false;

  Image getWorkspaceIcon(icon) {
    final iconPath = icon;
    if (iconPath.isEmpty) {
      return Image.asset(
        AppIcons.unknown,
        width: 96,
      );
    }
    if (iconPath.startsWith('assets/icons/picker')) {
      return Image.asset(
        iconPath,
        width: 96,
      );
    }
    return Image.file(
      File(iconPath),
      width: 96,
    );
  }

  Widget _buildAppBar() {
    List<Widget> apps = [];
    int count = -1;
    for (var app in widget.workspaceEntity.apps) {
      if (count == 3) {
        break;
      }
      count++;
      apps.add(Padding(
        padding:
            count != 0 ? EdgeInsets.only(left: (count * 25)) : EdgeInsets.zero,
        child: Container(
          decoration: BoxDecoration(
            color: AppTheme.floatingAppTileColor,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: AppTheme.floatingAppTileDropShadowColor,
                blurRadius: 16,
              )
            ],
          ),
          padding: const EdgeInsets.all(6),
          child: app.iconPath.endsWith('.svg')
              ? SvgPicture.asset(
                  app.appIconPath,
                  width: 24,
                  height: 24,
                )
              : Image.asset(
                  app.appIconPath,
                  width: 24,
                  filterQuality: FilterQuality.high,
                ),
        ).animate().scale(
            delay: const Duration(milliseconds: 500),
            duration: Duration(milliseconds: 600 + (count * 200))),
      ));
    }
    return Stack(
      children: [
        ...apps.reversed,
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (e) => setState(() => hover = true),
      onExit: (e) => setState(() => hover = false),
      child: Container(
        width: 200,
        height: 190,
        margin: const EdgeInsets.only(bottom: 12.0),
        child: Stack(
          children: [
            Align(
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                width: 160,
                height: 150,
                padding: const EdgeInsets.all(16.0),
                margin: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: AppTheme.workspaceTileColor,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: (AppTheme.isDarkMode()
                              ? AppTheme.dialogDropShadow
                              : accentColorMap[
                                  getAccentChar(widget.workspaceEntity.name)
                                      .toUpperCase()]!)
                          .withOpacity(hover ? 0.6 : 0.2),
                      blurRadius: 16,
                    ),
                  ],
                ),
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      AnimatedScale(
                        duration: const Duration(milliseconds: 500),
                        scale: hover ? 0.8 : 1.0,
                        child: getWorkspaceIcon(
                          widget.workspaceEntity.iconPath,
                        ),
                      ),
                      SizedBox(
                        width: 190,
                        child: Text(
                          widget.workspaceEntity.name,
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.ellipsis,
                          style: AppTheme.fontSize(14).makeBold(),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: SizedBox(
                child: _buildAppBar(),
              ),
            ),
            if (widget.isDefaultWorkspace)
              Align(
                alignment: Alignment.topCenter,
                child: AnimatedScale(
                  duration: const Duration(milliseconds: 500),
                  scale: hover ? 0.8 : 1.0,
                  child: Container(
                    decoration: BoxDecoration(
                      color: accentColorMap[
                              getAccentChar(widget.workspaceEntity.name)
                                  .toUpperCase()] ??
                          Colors.amber.shade700,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: AppTheme.dialogDropShadow,
                          blurRadius: 16,
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.all(4.0),
                    child: Icon(
                      Icons.star,
                      color: AppTheme.background,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
