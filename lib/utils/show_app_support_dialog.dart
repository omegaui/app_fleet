import 'package:app_fleet/config/assets/app_icons.dart';
import 'package:app_fleet/config/theme/app_theme.dart';
import 'package:app_fleet/constants/app_meta_info.dart';
import 'package:app_fleet/utils/app_window_buttons.dart';
import 'package:app_fleet/utils/show_app_info_dialog.dart';
import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';

void showAppSupportDialog({
  required BuildContext context,
}) {
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
                width: 500,
                height: 450,
                decoration: BoxDecoration(
                  color: AppTheme.background,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 16,
                    )
                  ],
                ),
                child: Stack(
                  children: [
                    Align(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            "Support the development of App Fleet",
                            textAlign: TextAlign.center,
                            style: AppTheme.fontSize(17).makeBold(),
                          ),
                          const SizedBox(height: 10),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(5),
                            child: Image.asset(
                              AppIcons.qrCode,
                              width: 350 / 1.2,
                            ),
                          ),
                          const SizedBox(height: 15),
                          Text(
                            "Scan this QR Code or",
                            textAlign: TextAlign.center,
                            style: AppTheme.fontSize(17).makeBold(),
                          ),
                          Text(
                            "Click the link below to Buy Me a Coffee",
                            textAlign: TextAlign.center,
                            style: AppTheme.fontSize(17).makeBold(),
                          ),
                          linkText(
                            text: AppMetaInfo.buyMeACoffeeProfileUrl,
                            url: AppMetaInfo.buyMeACoffeeProfileUrl,
                            fontSize: 14,
                            italic: false,
                          ),
                        ],
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
}
