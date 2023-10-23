import 'package:app_fleet/app/update/presentation/states/update_empty_state_view.dart';
import 'package:app_fleet/app/update/presentation/states/update_initialized_state_view.dart';
import 'package:app_fleet/app/update/presentation/update_controller.dart';
import 'package:app_fleet/app/update/presentation/update_state_machine.dart';
import 'package:app_fleet/constants/unrecognized_state_exception.dart';
import 'package:flutter/material.dart';

class UpdateView extends StatefulWidget {
  const UpdateView({super.key, this.arguments});

  final dynamic arguments;

  @override
  State<UpdateView> createState() => _UpdateViewState();
}

class _UpdateViewState extends State<UpdateView> {
  late UpdateController controller;

  @override
  void initState() {
    super.initState();
    controller = UpdateController(onRebuildRequested: () => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    final currentState = controller.getCurrentState();
    switch (currentState.runtimeType) {
      case UpdateEmptyState:
        return UpdateEmptyStateView(
            controller: controller, updateData: widget.arguments);
      case UpdateInitializedState:
        return UpdateInitializedStateView(
          controller: controller,
          updateData: widget.arguments,
          reinstall: (currentState as UpdateInitializedState).reinstall,
        );
      default:
        throw UnrecognizedStateException();
    }
  }
}
