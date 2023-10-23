import 'package:app_fleet/config/assets/app_icons.dart';
import 'package:app_fleet/config/theme/app_theme.dart';
import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

void showConfirmUninstallDialog({
  required BuildContext context,
  required void Function(bool uninstall) onSelection,
}) {
  void selectOption(bool uninstall) {
    Navigator.pop(context);
    onSelection(uninstall);
  }

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
                        vertical: 32.0,
                      ),
                      child: Image.asset(
                        AppIcons.uninstall,
                      ),
                    ),
                    Text(
                      "Do you really want to uninstall App Fleet?\nThis will also delete your workspace configurations.",
                      textAlign: TextAlign.center,
                      style: AppTheme.fontSize(14).makeBold(),
                    ).animate().fadeIn(
                          delay: const Duration(milliseconds: 50),
                        ),
                    const SizedBox(height: 40),
                    Wrap(
                      alignment: WrapAlignment.center,
                      spacing: 10.0,
                      children: [
                        TextButton(
                          onPressed: () => selectOption(true),
                          style: TextButton.styleFrom(
                            backgroundColor: AppTheme.negativeOptionBackground,
                            foregroundColor: AppTheme.negativeOptionForeground,
                          ),
                          child: Text(
                            "Uninstall",
                            style: AppTheme.fontSize(14)
                                .makeBold()
                                .withColor(AppTheme.negativeOptionForeground),
                          ),
                        ),
                        TextButton(
                          onPressed: () => selectOption(false),
                          style: TextButton.styleFrom(
                            backgroundColor:
                                AppTheme.recommendedOptionBackground,
                            foregroundColor:
                                AppTheme.recommendedOptionForeground,
                          ),
                          child: Text(
                            "Abort",
                            style: AppTheme.fontSize(14).makeBold().withColor(
                                AppTheme.recommendedOptionForeground),
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
