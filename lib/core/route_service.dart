import 'package:app_fleet/app/config/presentation/config_view.dart';
import 'package:app_fleet/app/home/presentation/home_view.dart';
import 'package:app_fleet/app/launcher/presentation/launcher_view.dart';
import 'package:app_fleet/config/theme/app_theme.dart';
import 'package:app_fleet/core/app_configuration.dart';
import 'package:app_fleet/core/dependency_manager.dart';
import 'package:app_fleet/utils/snack_bar_builder.dart';
import 'package:flutter/material.dart';

class RouteService {
  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  static const homeRoute = 'home';
  static const createRoute = 'create';
  static const launcherRoute = 'launcher';

  final VoidCallback onRebuildRequested;

  RouteService.withState({required this.onRebuildRequested});

  final Route unrecognizedRoute = Route(
      name: "unrecognized-route",
      builder: (arguments) {
        return const SizedBox();
      });

  String currentRoute = homeRoute;

  final routes = [
    Route(
      name: homeRoute,
      builder: (arguments) => HomeView(
        arguments: arguments,
      ),
    ),
    Route(
      name: createRoute,
      builder: (arguments) => ConfigView(
        arguments: arguments,
      ),
    ),
    Route(
      name: launcherRoute,
      builder: (arguments) => LauncherView(
        arguments: arguments,
      ),
    ),
  ];

  Route _getRoute(String name) {
    for (var route in routes) {
      if (route.name == name) {
        return route;
      }
    }
    return unrecognizedRoute;
  }

  void gotoRoute(String route, {dynamic arguments}) {
    currentRoute = route;
    _getRoute(currentRoute).arguments = arguments;
    onRebuildRequested();
  }

  void reloadApp() {
    DependencyInjection.find<AppConfiguration>().reload();
    gotoRoute(homeRoute);
    showSnackbar(
      icon: Icon(
        Icons.info_outlined,
        color: AppTheme.foreground,
      ),
      message: "Reloading from Disk Completed",
    );
  }

  Route getCurrentRoute() {
    return _getRoute(currentRoute);
  }
}

class Route {
  String name;
  dynamic arguments;
  Widget Function(dynamic) builder;

  Route({
    required this.name,
    this.arguments,
    required this.builder,
  });

  Widget getView() {
    return builder(arguments);
  }
}
