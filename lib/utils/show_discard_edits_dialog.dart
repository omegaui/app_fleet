import 'package:app_fleet/config/assets/app_icons.dart';
import 'package:app_fleet/config/theme/app_theme.dart';
import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

enum DiscardMode {
  save,
  continueEditing,
  discard,
}

void showDiscardEditsDialog({
  required BuildContext context,
  required void Function(DiscardMode mode) onSelection,
}) {
  void selectOption(DiscardMode mode) {
    Navigator.pop(context);
    onSelection(mode);
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
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.blueGrey.withOpacity(0.4),
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
                        AppIcons.discard,
                      ),
                    ),
                    Text(
                      "You have unsaved changes !!",
                      style: AppTheme.fontSize(16).makeBold(),
                    ).animate().fadeIn(
                          delay: const Duration(milliseconds: 50),
                        ),
                    const SizedBox(height: 40),
                    Wrap(
                      alignment: WrapAlignment.center,
                      spacing: 10.0,
                      children: [
                        TextButton(
                          onPressed: () => selectOption(DiscardMode.save),
                          style: TextButton.styleFrom(
                            backgroundColor: Colors.blue.withOpacity(0.2),
                            foregroundColor: Colors.blueAccent,
                          ),
                          child: Text(
                            "Save",
                            style: AppTheme.fontSize(14)
                                .makeBold()
                                .withColor(Colors.blueAccent),
                          ),
                        ),
                        TextButton(
                          onPressed: () =>
                              selectOption(DiscardMode.continueEditing),
                          style: TextButton.styleFrom(
                            backgroundColor: Colors.green.withOpacity(0.2),
                            foregroundColor: Colors.greenAccent,
                          ),
                          child: Text(
                            "Continue Editing",
                            style: AppTheme.fontSize(14)
                                .makeBold()
                                .withColor(Colors.green),
                          ),
                        ),
                        TextButton(
                          onPressed: () => selectOption(DiscardMode.discard),
                          style: TextButton.styleFrom(
                            backgroundColor: Colors.red.withOpacity(0.2),
                            foregroundColor: Colors.redAccent,
                          ),
                          child: Text(
                            "Discard",
                            style: AppTheme.fontSize(14)
                                .makeBold()
                                .withColor(Colors.redAccent),
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
