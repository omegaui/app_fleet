import 'dart:io';

import 'package:app_fleet/app/config/domain/workspace_entity.dart';
import 'package:app_fleet/config/assets/app_icons.dart';
import 'package:app_fleet/config/theme/app_theme.dart';
import 'package:app_fleet/utils/app_tooltip_builder.dart';
import 'package:app_fleet/utils/app_window_buttons.dart';
import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class WorkspaceIconBox extends StatefulWidget {
  const WorkspaceIconBox({
    super.key,
    required this.workspaceEntity,
  });

  final WorkspaceEntity workspaceEntity;

  @override
  State<WorkspaceIconBox> createState() => _WorkspaceIconBoxState();
}

class _WorkspaceIconBoxState extends State<WorkspaceIconBox> {
  bool hover = false;
  bool initialized = false;
  List<String> icons = [];

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 250), () async {
      icons = await AppIcons.loadPickerIcons();
      setState(() {
        initialized = true;
      });
    });
  }

  Widget _buildContent() {
    final iconPath = widget.workspaceEntity.iconPath;
    if (iconPath == '') {
      return Text(
        "Pick\nIcon",
        style: AppTheme.fontSize(14).makeItalic(),
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

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (event) => setState(() => hover = true),
      onExit: (event) => setState(() => hover = false),
      child: GestureDetector(
        onTap: () {
          showIconPicker(onSelected: (path) {
            if (path != null) {
              setState(() {
                widget.workspaceEntity.iconPath = path;
              });
            }
          });
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          width: initialized ? 120 : 30,
          height: initialized ? 120 : 30,
          decoration: BoxDecoration(
            color: initialized
                ? AppTheme.foreground.withOpacity(0.06)
                : AppTheme.background,
            borderRadius: BorderRadius.circular(100),
          ),
          margin: EdgeInsets.all(initialized ? 0 : 45),
          child: initialized
              ? Center(
                  child: _buildContent(),
                )
              : const CircularProgressIndicator(
                  color: Colors.blue,
                ),
        ),
      ),
    );
  }

  showIconPicker({required void Function(String? path) onSelected}) {
    icons.shuffle();
    bool hoverX = false;
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
              child: FittedBox(
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
                            children: [
                              Row(
                                children: [
                                  Text(
                                    "Pick an icon",
                                    style: AppTheme.fontSize(18).makeBold(),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 200,
                                child: SingleChildScrollView(
                                  child: Wrap(
                                    children: [
                                      ...icons.map((e) {
                                        bool hover = false;
                                        return GestureDetector(
                                          onTap: () {
                                            onSelected(e);
                                            Navigator.pop(context);
                                          },
                                          child: StatefulBuilder(
                                            builder: (context, setState) {
                                              return MouseRegion(
                                                onEnter: (e) => setState(
                                                    () => hover = true),
                                                onExit: (e) => setState(
                                                    () => hover = false),
                                                child: AnimatedOpacity(
                                                  opacity: hover ? 1.0 : 0.7,
                                                  duration: const Duration(
                                                      milliseconds: 250),
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            10.0),
                                                    child: Image.asset(
                                                      e,
                                                      width: 48,
                                                    ),
                                                  ),
                                                ),
                                              );
                                            },
                                          ),
                                        );
                                      }).toList(),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: AppTooltipBuilder.wrap(
                            text: "Choose from system files",
                            child: GestureDetector(
                              onTap: () async {
                                void closeDialog() {
                                  Navigator.pop(context);
                                }

                                FilePickerResult? result =
                                    await FilePicker.platform.pickFiles(
                                  type: FileType.image,
                                );
                                if (result != null) {
                                  onSelected(result.files.single.path!);
                                  closeDialog();
                                }
                              },
                              child: StatefulBuilder(
                                builder: (context, setState) {
                                  return MouseRegion(
                                    onEnter: (e) =>
                                        setState(() => hoverX = true),
                                    onExit: (e) =>
                                        setState(() => hoverX = false),
                                    child: AnimatedContainer(
                                      duration:
                                          const Duration(milliseconds: 250),
                                      width: 50,
                                      height: 50,
                                      decoration: BoxDecoration(
                                        color: AppTheme.fieldPrimaryColor
                                            .withOpacity(hoverX ? 0.1 : 0.3),
                                        borderRadius: BorderRadius.circular(50),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: Icon(
                                          Icons.edit_location_alt,
                                          color: AppTheme.safeOptionForeground,
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.topRight,
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: appWindowButton(
                            color: Colors.red,
                            onPressed: () {
                              onSelected(null);
                              Navigator.pop(context);
                            },
                          ),
                        ),
                      ),
                    ],
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
