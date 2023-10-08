import 'package:app_fleet/config/assets/app_icons.dart';
import 'package:app_fleet/config/theme/app_theme.dart';
import 'package:app_fleet/core/app_bug_report.dart';
import 'package:app_fleet/core/route_service.dart';
import 'package:app_fleet/main.dart';
import 'package:app_fleet/utils/app_window_buttons.dart';
import 'package:app_fleet/utils/utils.dart';
import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';

bool _visible = false;

void showBugReports() {
  if (_visible) {
    return;
  }
  _visible = true;
  debugPrintApp(">> Showing Bug Report Dialog");
  showDialog(
    context: RouteService.navigatorKey.currentContext!,
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
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              AppIcons.bug,
                              width: 48,
                            ),
                            Text(
                              "Error Occurred",
                              style: AppTheme.fontSize(18)
                                  .makeBold()
                                  .withColor(Colors.red),
                            ),
                            Text(
                              "Automatic Bug Report Generated",
                              style: AppTheme.fontSize(12),
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  "Click to view the",
                                  style: AppTheme.fontSize(12).makeItalic(),
                                ),
                                const SizedBox(width: 2),
                                linkText(
                                  text: "Bug Report",
                                  url: getBugReportPath(
                                      AppBugReport.reportIDs.last),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  "Please upload the bug report",
                                  style: AppTheme.fontSize(12),
                                ),
                                const SizedBox(width: 2),
                                linkText(
                                  text: "here",
                                  url:
                                      'https://github.com/omegaui/app-fleet/issues/new',
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
                            _visible = false;
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
