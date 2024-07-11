import 'package:app_fleet/app/home/presentation/home_controller.dart';
import 'package:app_fleet/app/home/presentation/widgets/create_button.dart';
import 'package:app_fleet/config/assets/app_animations.dart';
import 'package:app_fleet/config/theme/app_theme.dart';
import 'package:app_fleet/core/storage_manager.dart';
import 'package:app_fleet/utils/app_top_bar.dart';
import 'package:app_fleet/utils/bottom_bar.dart';
import 'package:app_fleet/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class HomeEmptyStateView extends StatefulWidget {
  const HomeEmptyStateView({
    super.key,
    required this.controller,
  });

  final HomeController controller;

  @override
  State<HomeEmptyStateView> createState() => _HomeEmptyStateViewState();
}

class _HomeEmptyStateViewState extends State<HomeEmptyStateView> {

  @override
  void initState() {
    super.initState();
    scanForMissingComponent();
  }

  @override
  Widget build(BuildContext context) {
    AppStorageManager.checkScripts(context: context);
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          Align(
            child: Container(
              width: 700,
              height: 500,
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
              child: Column(
                children: [
                  appBar(context),
                  Lottie.asset(AppAnimations.empty, width: 350, repeat: false),
                  Text(
                    "Couldn't find any workspace configs on this system",
                    style: AppTheme.fontSize(14),
                  ),
                  const SizedBox(height: 5),
                  CreateButton(
                    onPressed: () {
                      widget.controller.gotoCreateRoute();
                    },
                  ),
                ],
              ),
            ),
          ),
          bottomBar(
            text: "Welcome to App Fleet",
          ),
        ],
      ),
    );
  }
}
