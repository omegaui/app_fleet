import 'package:app_fleet/config/theme/app_theme.dart';
import 'package:flutter/material.dart';

class AppTooltipBuilder {
  static Widget wrap({text, child}) {
    if (text.isEmpty) {
      return child;
    }
    return Tooltip(
      message: text,
      waitDuration: const Duration(milliseconds: 250),
      textAlign: TextAlign.center,
      textStyle: TextStyle(
        fontFamily: "Sen",
        fontSize: 14,
        fontWeight: FontWeight.bold,
        color: AppTheme.foreground,
      ),
      decoration: BoxDecoration(
        color: AppTheme.background,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: AppTheme.dialogDropShadow.withOpacity(0.4),
            blurRadius: 16,
          ),
        ],
      ),
      padding: const EdgeInsets.all(10.0),
      child: child,
    );
  }
}
