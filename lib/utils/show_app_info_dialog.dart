import 'package:app_fleet/config/assets/app_icons.dart';
import 'package:app_fleet/config/theme/app_theme.dart';
import 'package:app_fleet/constants/app_meta_info.dart';
import 'package:app_fleet/utils/app_tooltip_builder.dart';
import 'package:app_fleet/utils/app_window_buttons.dart';
import 'package:app_fleet/utils/show_app_support_dialog.dart';
import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';

void showAppInfo(BuildContext context) {
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
                width: 250,
                height: 235,
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
                        padding: const EdgeInsets.symmetric(vertical: 20.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const SizedBox(height: 5),
                            Image.asset(
                              AppIcons.appFleet,
                              width: 48,
                            ),
                            Text(
                              "App Fleet",
                              style: AppTheme.fontSize(18).makeBold(),
                            ),
                            Text(
                              "Workspace Manager & Launcher",
                              style: AppTheme.fontSize(14),
                            ),
                            Text(
                              AppMetaInfo.version,
                              style: AppTheme.fontSize(13),
                            ),
                            const SizedBox(height: 5),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  "Proudly Crafted by",
                                  style: AppTheme.fontSize(12).makeItalic(),
                                ),
                                const SizedBox(width: 2),
                                linkText(
                                  text: "omegaui",
                                  url: "https://github.com/omegaui",
                                ),
                              ],
                            ),
                            const SizedBox(height: 2),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                AppTooltipBuilder.wrap(
                                  text: "See Source Code",
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(40),
                                    child: Material(
                                      color: Colors.white,
                                      child: IconButton(
                                        onPressed: () {
                                          launchUrlString(
                                              AppMetaInfo.sourceCodeUrl);
                                        },
                                        icon: Image.asset(
                                          AppIcons.github,
                                          width: 32,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 10.0),
                                AppTooltipBuilder.wrap(
                                  text: "Support the Development of App Fleet",
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(40),
                                    child: Material(
                                      color: Colors.white,
                                      child: IconButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                          showAppSupportDialog(
                                              context: context);
                                        },
                                        icon: Image.asset(
                                          AppIcons.buyMeACoffee,
                                          width: 32,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
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

Widget linkText(
    {required String text,
    required String url,
    double? fontSize,
    bool italic = true}) {
  bool hover = false;
  return StatefulBuilder(
    builder: (context, setState) {
      return MouseRegion(
        onEnter: (event) => setState(() => hover = true),
        onExit: (event) => setState(() => hover = false),
        child: GestureDetector(
          onTap: () {
            launchUrlString(url);
          },
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 250),
            transitionBuilder: (child, animation) {
              return FadeTransition(
                opacity: animation,
                child: child,
              );
            },
            child: hover
                ? Text(
                    text,
                    key: const ValueKey("hover"),
                    style: AppTheme.fontSize(fontSize ?? 12)
                        .withColor(Colors.green)
                        .makeBold(),
                  )
                : italic
                    ? Text(
                        text,
                        key: const ValueKey("normal"),
                        style: AppTheme.fontSize(fontSize ?? 12)
                            .withColor(Colors.blue)
                            .makeBold()
                            .makeItalic(),
                      )
                    : Text(
                        text,
                        key: const ValueKey("normal"),
                        style: AppTheme.fontSize(fontSize ?? 12)
                            .withColor(Colors.blue)
                            .makeBold(),
                      ),
          ),
        ),
      );
    },
  );
}
