import 'package:app_fleet/config/assets/app_icons.dart';
import 'package:app_fleet/config/theme/app_theme.dart';
import 'package:app_fleet/constants/app_meta_info.dart';
import 'package:app_fleet/utils/app_window_buttons.dart';
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
                height: 175,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.4),
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
                          children: [
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

Widget linkText({required String text, required String url}) {
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
                    style: AppTheme.fontSize(12)
                        .withColor(Colors.green)
                        .makeBold(),
                  )
                : Text(
                    text,
                    key: const ValueKey("normal"),
                    style: AppTheme.fontSize(12)
                        .withColor(Colors.blue)
                        .makeBold()
                        .makeItalic(),
                  ),
          ),
        ),
      );
    },
  );
}
