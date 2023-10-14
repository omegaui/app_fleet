import 'package:app_fleet/config/theme/app_theme.dart';
import 'package:flutter/material.dart';

Widget bottomBar({required String text}) {
  return Align(
    alignment: Alignment.bottomCenter,
    child: Padding(
      padding: const EdgeInsets.only(bottom: 38.0),
      child: FittedBox(
        child: Container(
          height: 30,
          decoration: BoxDecoration(
            color: AppTheme.background,
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                color: AppTheme.windowDropShadow,
                offset: const Offset(0, 2),
                blurRadius: 2,
              ),
            ],
          ),
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Center(
            child: Text(
              text,
              style: AppTheme.fontSize(16),
            ),
          ),
        ),
      ),
    ),
  );
}
