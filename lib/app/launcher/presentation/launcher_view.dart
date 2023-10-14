import 'package:app_fleet/app/launcher/presentation/launcher_controller.dart';
import 'package:app_fleet/app/launcher/presentation/launcher_state_machine.dart';
import 'package:app_fleet/app/launcher/presentation/states/launcher_empty_state_view.dart';
import 'package:app_fleet/app/launcher/presentation/states/launcher_initialized_state_view.dart';
import 'package:app_fleet/constants/unrecognized_state_exception.dart';
import 'package:flutter/material.dart';

class LauncherView extends StatefulWidget {
  const LauncherView({super.key, this.arguments});

  final dynamic arguments;

  @override
  State<LauncherView> createState() => _LauncherViewState();
}

class _LauncherViewState extends State<LauncherView> {
  late LauncherController controller;

  @override
  void initState() {
    super.initState();
    controller = LauncherController(onRebuildRequested: () => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    final currentState = controller.getCurrentState();
    switch (currentState.runtimeType) {
      case LauncherEmptyState:
        return LauncherEmptyStateView(controller: controller);
      case LauncherInitializedState:
        return LauncherInitializedStateView(controller: controller);
      default:
        throw UnrecognizedStateException();
    }
  }
}
