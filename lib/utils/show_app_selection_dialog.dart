import 'package:app_fleet/app/config/domain/workspace_entity.dart';
import 'package:app_fleet/app/settings/data/settings_repository.dart';
import 'package:app_fleet/config/assets/app_icons.dart';
import 'package:app_fleet/config/assets/generators/linux_app_finder.dart';
import 'package:app_fleet/config/theme/app_theme.dart';
import 'package:app_fleet/core/dependency_manager.dart';
import 'package:app_fleet/utils/app_tooltip_builder.dart';
import 'package:app_fleet/utils/app_window_buttons.dart';
import 'package:app_fleet/utils/utils.dart';
import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

void showAppSelectionDialog({
  required BuildContext context,
  required void Function(App? app) onClick,
}) {
  String searchText = "";
  FocusNode focusNode = FocusNode();
  Future.delayed(const Duration(milliseconds: 250), () {
    focusNode.requestFocus();
  });
  String title = "Pick an App (${LinuxAppFinder.apps.length} Detected)";
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
            child: FittedBox(
              child: Container(
                width: 500,
                height: 420,
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
                child: StatefulBuilder(builder: (context, setState) {
                  return CallbackShortcuts(
                    bindings: {
                      const SingleActivator(LogicalKeyboardKey.f4, alt: true):
                          () => Navigator.pop(context),
                    },
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
                                      title,
                                      style: AppTheme.fontSize(18).makeBold(),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 350,
                                  child: SingleChildScrollView(
                                    child: Wrap(
                                      children: [
                                        ...LinuxAppFinder.apps
                                            .where((e) => containsIgnoreCase(
                                                e.name, searchText))
                                            .map((e) {
                                          bool hover = false;
                                          return GestureDetector(
                                            onTap: () {
                                              onClick(e);
                                              if (!settingsRepo
                                                  .getKeepAppPickerOpen()) {
                                                Navigator.pop(context);
                                              } else {
                                                setState(() {
                                                  title = "Added ${e.name}";
                                                });
                                              }
                                            },
                                            child: StatefulBuilder(
                                              builder: (context, setIconState) {
                                                return MouseRegion(
                                                  onEnter: (e) => setIconState(
                                                      () => hover = true),
                                                  onExit: (e) => setIconState(
                                                      () => hover = false),
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            10.0),
                                                    child: SizedBox(
                                                      width: 48,
                                                      height: 48,
                                                      child: AnimatedScale(
                                                        duration:
                                                            const Duration(
                                                                milliseconds:
                                                                    250),
                                                        scale:
                                                            hover ? 0.8 : 1.0,
                                                        child: AppTooltipBuilder
                                                            .wrap(
                                                          text: e.name,
                                                          child: e.iconPath
                                                                  .endsWith(
                                                                      ".svg")
                                                              ? SvgPicture
                                                                  .asset(
                                                                  e.iconPath,
                                                                  width: 48,
                                                                  placeholderBuilder:
                                                                      (context) =>
                                                                          Image
                                                                              .asset(
                                                                    AppIcons
                                                                        .unknown,
                                                                    width: 48,
                                                                  ),
                                                                )
                                                              : Image.asset(
                                                                  e.iconPath,
                                                                  width: 48,
                                                                ),
                                                        ),
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
                          alignment: Alignment.bottomCenter,
                          child: SizedBox(
                            width: 120,
                            child: TextField(
                              focusNode: focusNode,
                              textAlign: TextAlign.center,
                              style: AppTheme.fontSize(14).makeBold(),
                              decoration: InputDecoration(
                                hintText: "Search by Name",
                                hintStyle: AppTheme.fontSize(14).makeBold(),
                              ),
                              onChanged: (value) {
                                setState(() {
                                  searchText = value;
                                });
                              },
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
                                onClick(null);
                                Navigator.pop(context);
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ),
            ),
          ),
        ),
      );
    },
  );
}
