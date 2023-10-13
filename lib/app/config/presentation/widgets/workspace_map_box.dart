import 'package:app_fleet/app/config/domain/workspace_entity.dart';
import 'package:app_fleet/config/theme/app_theme.dart';
import 'package:app_fleet/utils/show_workspace_map_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class WorkspaceMapBox extends StatefulWidget {
  const WorkspaceMapBox({
    super.key,
    required this.workspaceEntity,
    required this.onRebuildRequested,
  });

  final WorkspaceEntity workspaceEntity;
  final VoidCallback onRebuildRequested;

  @override
  State<WorkspaceMapBox> createState() => _WorkspaceMapBoxState();
}

class _WorkspaceMapBoxState extends State<WorkspaceMapBox> {
  Map<int, List<App>> workspaceMap = {};
  int maxPriority = 1;

  @override
  void initState() {
    super.initState();
    inferMaxPriority();
  }

  void inferMaxPriority() {
    // App priority number decides the workspace number to which the app belongs
    maxPriority = 1;
    int minPriority = widget.workspaceEntity.apps.first.priority;
    workspaceMap = {};
    for (var app in widget.workspaceEntity.apps) {
      workspaceMap[app.priority] = [];
      if (maxPriority < app.priority) {
        maxPriority = app.priority;
      }
      if (minPriority > app.priority) {
        minPriority = app.priority;
      }
    }
    // Gnome Fixed Mode supports at most 36 workspaces
    if (maxPriority <= 36) {
      workspaceMap[maxPriority] = [];
    }
    // we must show workspace numbers starting from the first
    if (minPriority > 0) {
      for (var i = 0; i < minPriority; i++) {
        workspaceMap[i] = [];
      }
    }
    for (var app in widget.workspaceEntity.apps) {
      workspaceMap[app.priority]!.add(app);
    }
    if (workspaceMap[maxPriority]!.isNotEmpty && maxPriority < 36) {
      if (widget.workspaceEntity.apps.length - 1 > maxPriority) {
        workspaceMap[++maxPriority] = [];
      }
    } else if (workspaceMap[maxPriority - 1]!.isEmpty) {
      workspaceMap.remove(maxPriority--);
    }
    Map<int, List<App>> backup = {...workspaceMap};
    List<int> workspaces = workspaceMap.keys.toList()..sort();
    workspaceMap = {};
    for (var workspace in workspaces) {
      workspaceMap[workspace] = backup[workspace]!;
    }
  }

  List<Widget> _buildContent() {
    return workspaceMap.entries.map(
      (app) {
        int count = app.key;
        bool hover = false;
        return GestureDetector(
          onTap: () {
            showWorkspaceMapDialog(
              priority: count,
              workspaceEntity: widget.workspaceEntity,
              context: context,
              maxPriority: maxPriority,
              getWorkspaceMapCallback: () => workspaceMap,
              onMapUpdate: () {
                setState(() {
                  inferMaxPriority();
                  widget.onRebuildRequested();
                });
              },
            );
          },
          child: StatefulBuilder(
            builder: (context, setState) {
              return MouseRegion(
                onEnter: (e) => setState(() => hover = true),
                onExit: (e) => setState(() => hover = false),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  width: 40,
                  height: 40,
                  margin: const EdgeInsets.symmetric(horizontal: 2.0),
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  decoration: BoxDecoration(
                    color: AppTheme.configLabelBackground
                        .withOpacity(hover ? 0.4 : 0.2),
                    borderRadius: BorderRadius.circular(40),
                  ),
                  child: Center(
                    child: Text(
                      (count + 1).toString(),
                      style: AppTheme.fontSize(20),
                    ),
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
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.grey.withOpacity(0.2),
            borderRadius: BorderRadius.circular(30),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 3.0),
          margin: const EdgeInsets.symmetric(vertical: 8.0),
          child: Text(
            "Map Apps to specific Workspaces",
            style: AppTheme.fontSize(16)
                .makeBold()
                .withColor(Colors.grey.shade800),
          ).animate().shimmer(
              delay: const Duration(seconds: 1),
              duration: const Duration(seconds: 2)),
        ),
        Wrap(
          runSpacing: 5.0,
          children: [
            ..._buildContent(),
          ],
        ),
      ],
    );
  }
}
