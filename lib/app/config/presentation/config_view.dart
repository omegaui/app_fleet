import 'package:app_fleet/app/config/domain/workspace_entity.dart';
import 'package:app_fleet/app/config/presentation/config_controller.dart';
import 'package:app_fleet/app/config/presentation/config_state_machine.dart';
import 'package:app_fleet/app/config/presentation/states/config_initialized_state_view.dart';
import 'package:app_fleet/constants/unrecognized_state_exception.dart';
import 'package:flutter/material.dart';

class ConfigView extends StatefulWidget {
  const ConfigView({
    super.key,
    this.arguments,
  });

  final dynamic arguments;

  @override
  State<ConfigView> createState() => _ConfigViewState();
}

class _ConfigViewState extends State<ConfigView> {
  late ConfigController controller;

  @override
  void initState() {
    super.initState();
    controller = ConfigController(
      onRebuildRequested: () => setState(() {}),
      state: widget.arguments != null
          ? ConfigInitializedState(
              workspaceEntity: widget.arguments,
            )
          : null,
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentState = controller.getCurrentState();
    switch (currentState.runtimeType) {
      case ConfigInitializationState:
        return ConfigInitializedStateView(
          controller: controller,
          workspaceEntity: WorkspaceEntity.clone(WorkspaceEntity.empty),
          configUIMode: ConfigUIMode.create,
        );
      case ConfigInitializedState:
        return ConfigInitializedStateView(
          controller: controller,
          workspaceEntity:
              (currentState as ConfigInitializedState).workspaceEntity,
          configUIMode: ConfigUIMode.edit,
        );
      default:
        throw UnrecognizedStateException();
    }
  }
}
