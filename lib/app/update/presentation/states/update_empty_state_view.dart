import 'package:app_fleet/app/update/presentation/update_controller.dart';
import 'package:app_fleet/config/assets/app_animations.dart';
import 'package:app_fleet/config/theme/app_theme.dart';
import 'package:app_fleet/core/app_updater.dart';
import 'package:app_fleet/utils/bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class UpdateEmptyStateView extends StatelessWidget {
  const UpdateEmptyStateView({
    super.key,
    required this.controller,
    required this.updateData,
  });

  final UpdateController controller;
  final UpdateData updateData;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          Align(
            child: Container(
              width: 400,
              height: 300,
              decoration: BoxDecoration(
                color: AppTheme.background,
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.windowDropShadow,
                    blurRadius: 16,
                  ),
                ],
              ),
              child: Stack(
                children: [
                  Align(
                    child: Lottie.asset(
                      AppAnimations.startUpdate,
                      width: 200,
                      reverse: true,
                    ),
                  ),
                  Align(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "App Fleet ${updateData.data}",
                          style: AppTheme.fontSize(20).makeBold(),
                        ),
                        Text(
                          updateData.title,
                          style: AppTheme.fontSize(16).makeExtraBold(),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          "Bundle Size: ${updateData.size}",
                          style: AppTheme.fontSize(14),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            TextButton(
                              onPressed: () {
                                controller.showUpdatePage();
                              },
                              style: TextButton.styleFrom(
                                backgroundColor: AppTheme.dialogDropShadow,
                                foregroundColor: AppTheme.safeOptionForeground,
                              ),
                              child: Text(
                                "Start Update",
                                style: AppTheme.fontSize(14).makeBold(),
                              ),
                            ),
                            const SizedBox(width: 10),
                            TextButton(
                              onPressed: () {
                                controller.showUpdatePage(reinstall: true);
                              },
                              style: TextButton.styleFrom(
                                backgroundColor: AppTheme.dialogDropShadow,
                                foregroundColor: AppTheme.safeOptionForeground,
                              ),
                              child: Text(
                                "Reinstall",
                                style: AppTheme.fontSize(14).makeBold(),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 30.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.info,
                            color: AppTheme.negativeOptionForeground,
                          ),
                          const SizedBox(width: 5),
                          Text(
                            "Reinstalling will remove your workspace configs!",
                            style: AppTheme.fontSize(12).makeBold(),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 100.0),
            child: bottomBar(
              text: "App Fleet Updater",
            ),
          ),
        ],
      ),
    );
  }
}
