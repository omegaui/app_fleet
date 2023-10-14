import 'package:app_fleet/config/assets/app_animations.dart';
import 'package:app_fleet/config/theme/app_theme.dart';
import 'package:app_fleet/constants/app_meta_info.dart';
import 'package:app_fleet/core/app_updater.dart';
import 'package:app_fleet/core/route_service.dart';
import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lottie/lottie.dart';
import 'package:url_launcher/url_launcher_string.dart';

void showUpdateAvailableDialog({required UpdateData data}) {
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
                width: 450,
                height: 350,
                decoration: BoxDecoration(
                  color: AppTheme.background,
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.dialogDropShadow,
                      blurRadius: 16,
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16.0,
                        vertical: 10.0,
                      ),
                      child: Lottie.asset(
                        AppAnimations.update,
                        width: 192,
                        repeat: false,
                      ),
                    ),
                    Text(
                      "App Fleet ${data.data} is available",
                      style: AppTheme.fontSize(16).makeBold(),
                    ).animate().fadeIn(
                          delay: const Duration(milliseconds: 250),
                        ),
                    Text(
                      "You can update App Fleet seamlessly",
                      style: AppTheme.fontSize(14).makeBold(),
                    ).animate().fadeIn(
                          delay: const Duration(milliseconds: 250),
                        ),
                    const SizedBox(height: 20),
                    Wrap(
                      alignment: WrapAlignment.center,
                      spacing: 10.0,
                      children: [
                        TextButton(
                          onPressed: () {
                            launchUrlString(AppMetaInfo.releasePageUrl);
                            Navigator.pop(context);
                          },
                          style: TextButton.styleFrom(
                            backgroundColor:
                                AppTheme.recommendedOptionBackground,
                            foregroundColor:
                                AppTheme.recommendedOptionForeground,
                          ),
                          child: Text(
                            "See updating",
                            style: AppTheme.fontSize(14).makeBold().withColor(
                                AppTheme.recommendedOptionForeground),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          style: TextButton.styleFrom(
                            backgroundColor: AppTheme.negativeOptionBackground,
                            foregroundColor: AppTheme.negativeOptionForeground,
                          ),
                          child: Text(
                            "Ignore",
                            style: AppTheme.fontSize(14)
                                .makeBold()
                                .withColor(AppTheme.negativeOptionForeground),
                          ),
                        ),
                      ],
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
