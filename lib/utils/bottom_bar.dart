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
            color: Colors.white,
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                color: Colors.blueGrey.withOpacity(0.4),
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
