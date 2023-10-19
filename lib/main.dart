import 'dart:async';
import 'dart:io';

import 'package:app_fleet/config/assets/app_icons.dart';
import 'package:app_fleet/config/assets/generators/linux_app_finder.dart';
import 'package:app_fleet/config/theme/app_theme.dart';
import 'package:app_fleet/constants/app_meta_info.dart';
import 'package:app_fleet/core/app_man_page.dart';
import 'package:app_fleet/core/app_session.dart';
import 'package:app_fleet/core/app_updater.dart';
import 'package:app_fleet/core/dependency_manager.dart';
import 'package:app_fleet/core/route_service.dart';
import 'package:app_fleet/core/storage_manager.dart';
import 'package:app_fleet/utils/show_bug_report_dialog.dart';
import 'package:app_fleet/utils/utils.dart';
import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

bool launcherMode = false;
bool debugMode = false;
Size windowSize = const Size(750, 600);

void debugPrintApp(String data) {
  if (debugMode) {
    stdout.writeln(data);
  }
}

void main(List<String> args) async {
  if (args.isNotEmpty) {
    debugMode = args.contains("--debug");
    launcherMode = args.contains("--mode") &&
        args.contains("launcher") &&
        launcherModeCapable();

    AppManPage.handleHelpContext(args);

    if (launcherMode) {
      windowSize = const Size(530, 300);
    }
  }

  debugPrintApp(launcherMode ? ">> Launcher Mode" : ">> Manager Mode");

  WidgetsFlutterBinding.ensureInitialized();

  doWhenWindowReady(() {
    appWindow.minSize = windowSize;
    appWindow.maxSize = windowSize;
    appWindow.size = windowSize;
    appWindow.show();
  });

  await AppStorageManager.initSpace();

  runApp(AppFleet(launcherMode: launcherMode));
}

class AppFleet extends StatefulWidget {
  const AppFleet({super.key, required this.launcherMode});

  final bool launcherMode;

  @override
  State<AppFleet> createState() => _AppFleetState();
}

class _AppFleetState extends State<AppFleet> {
  bool initialized = false;
  late RouteService routeService;
  StreamSubscription<ConnectivityResult>? connectivitySubscription;

  @override
  void initState() {
    super.initState();
    DependencyInjection.injectDependencies(
      onRebuildRequested: () => setState(() {}),
      onInjectorFinished: () async {
        AppTheme.initTheme();
        DependencyInjection.find<AppSession>().addListener(() {
          showBugReports();
        });
        if (!launcherMode) {
          connectivitySubscription =
              DependencyInjection.find<AppUpdater>().init();
        }
        initialized = true;
        setState(() {});
      },
    );
    routeService = DependencyInjection.find<RouteService>();
    if (!launcherMode) {
      DependencyInjection.find<LinuxAppFinder>().initialize();
    } else {
      routeService.currentRoute = RouteService.launcherRoute;
    }
  }

  @override
  void dispose() {
    connectivitySubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(30),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: "App Fleet",
        color: Colors.transparent,
        theme: ThemeData(useMaterial3: true),
        home: SizedBox.fromSize(
          size: windowSize,
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 500),
            transitionBuilder: (child, animation) {
              return FadeTransition(
                opacity: animation,
                child: child,
              );
            },
            child: initialized
                ? MoveWindow(
                    onDoubleTap: () {
                      // this will prevent maximize operation
                    },
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 500),
                      transitionBuilder: (child, animation) {
                        return ScaleTransition(
                          scale: animation,
                          child: child,
                        );
                      },
                      child: routeService.getCurrentRoute().getView(),
                    ))
                : _splash(context),
          ),
        ),
        navigatorKey: RouteService.navigatorKey,
      ),
    );
  }
}

// Honestly, this splash never comes up on performant machines
Widget _splash(BuildContext context) {
  return Scaffold(
    backgroundColor: Colors.transparent,
    body: Center(
      child: FittedBox(
        child: Container(
          width: 200,
          height: 200,
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
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  AppIcons.appFleet,
                ),
                Text(
                  "App Fleet",
                  style: AppTheme.fontSize(22).makeBold(),
                ),
                Text(
                  AppMetaInfo.version,
                  style: AppTheme.fontSize(18).makeItalic(),
                ),
              ],
            ),
          ),
        ).animate().shimmer(
            delay: const Duration(milliseconds: 200),
            duration: const Duration(milliseconds: 500)),
      ),
    ),
  );
}
