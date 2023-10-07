import 'package:app_fleet/app/home/presentation/home_controller.dart';
import 'package:app_fleet/app/home/presentation/home_state_machine.dart';
import 'package:app_fleet/app/home/presentation/states/home_empty_state_view.dart';
import 'package:app_fleet/app/home/presentation/states/home_initialized_state_view.dart';
import 'package:app_fleet/constants/unrecognized_state_exception.dart';
import 'package:flutter/material.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key, this.arguments});

  final dynamic arguments;

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  late HomeController controller;

  @override
  void initState() {
    super.initState();
    controller = HomeController(onRebuildRequested: () => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    final currentState = controller.getCurrentState();
    switch (currentState.runtimeType) {
      case HomeEmptyState:
        return HomeEmptyStateView(controller: controller);
      case HomeInitializedState:
        return HomeInitializedStateView(controller: controller);
      default:
        throw UnrecognizedStateException();
    }
  }
}
