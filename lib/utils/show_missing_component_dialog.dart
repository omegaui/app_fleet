import 'package:app_fleet/config/assets/app_animations.dart';
import 'package:app_fleet/config/assets/app_icons.dart';
import 'package:app_fleet/config/theme/app_theme.dart';
import 'package:app_fleet/constants/app_meta_info.dart';
import 'package:app_fleet/core/logger.dart';
import 'package:app_fleet/utils/app_tooltip_builder.dart';
import 'package:app_fleet/utils/app_window_buttons.dart';
import 'package:app_fleet/utils/show_app_support_dialog.dart';
import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:url_launcher/url_launcher_string.dart';

bool _isVisible = false;

void showMissingComponentDialog(BuildContext context) async {
  if (_isVisible) {
    return;
  }
  _isVisible = true;
  await showDialog(
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
                width: 350,
                height: 335,
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
                            Lottie.asset(
                              AppAnimations.connection,
                              width: 200,
                            ),
                            Text(
                              "wmctrl is not installed",
                              style: AppTheme.fontSize(12).makeBold(),
                            ),
                            Text(
                              "cannot switch workspaces",
                              style: AppTheme.fontSize(12).makeBold(),
                            ),
                            const SizedBox(height: 5),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 5, vertical: 3),
                              decoration: BoxDecoration(
                                color: Colors.grey.shade100,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                "sudo apt install wmctrl",
                                style: AppTheme.fontSize(13)
                                    .makeBold()
                                    .withColor(Colors.grey.shade700),
                              ),
                            ),
                            const SizedBox(height: 5),
                            linkText(
                              text: 'or see instructions',
                              url: 'https://github.com/omegaui/app_fleet#hey-look-here',
                              fontSize: 13,
                              italic: false,
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
  _isVisible = false;
}

Widget linkText({
  required String text,
  required String url,
  double? fontSize,
  bool italic = true,
}) {
  bool hover = false;
  return StatefulBuilder(
    builder: (context, setState) {
      return MouseRegion(
        onEnter: (event) => setState(() => hover = true),
        onExit: (event) => setState(() => hover = false),
        child: GestureDetector(
          onTap: () {
            launchUrlString(url);
            prettyLog(
              value: url,
              type: DebugType.url,
            );
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
