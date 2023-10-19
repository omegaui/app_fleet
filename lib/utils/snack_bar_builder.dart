import 'package:app_fleet/config/theme/app_theme.dart';
import 'package:app_fleet/core/route_service.dart';
import 'package:flutter/material.dart';

void showSnackbar({
  required Icon icon,
  required String message,
}) {
  ScaffoldMessenger.of(RouteService.navigatorKey.currentContext!).showSnackBar(
    SnackBar(
      behavior: SnackBarBehavior.floating,
      margin: const EdgeInsets.symmetric(horizontal: 200, vertical: 200),
      backgroundColor: AppTheme.background,
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      content: Row(
        children: [
          icon,
          const SizedBox(width: 10.0),
          Text(
            message,
            style: AppTheme.fontSize(14),
          ),
        ],
      ),
    ),
  );
}
