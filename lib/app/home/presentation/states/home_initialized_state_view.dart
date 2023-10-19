import 'package:app_fleet/app/config/domain/workspace_entity.dart';
import 'package:app_fleet/app/home/presentation/home_controller.dart';
import 'package:app_fleet/app/home/presentation/widgets/workspace_tile.dart';
import 'package:app_fleet/app/settings/data/settings_repository.dart';
import 'package:app_fleet/config/theme/app_theme.dart';
import 'package:app_fleet/core/dependency_manager.dart';
import 'package:app_fleet/utils/app_top_bar.dart';
import 'package:app_fleet/utils/bottom_bar.dart';
import 'package:flutter/material.dart';

class HomeInitializedStateView extends StatefulWidget {
  const HomeInitializedStateView({
    super.key,
    required this.controller,
  });

  final HomeController controller;

  @override
  State<HomeInitializedStateView> createState() =>
      _HomeInitializedStateViewState();
}

class _HomeInitializedStateViewState extends State<HomeInitializedStateView> {
  late Set<WorkspaceEntity> workspaces;

  final settingsRepo = DependencyInjection.find<SettingsRepository>();

  @override
  void initState() {
    super.initState();
    onUpdate();
  }

  @override
  void didUpdateWidget(covariant HomeInitializedStateView oldWidget) {
    super.didUpdateWidget(oldWidget);
    onUpdate();
  }

  void onUpdate() {
    workspaces = widget.controller.getWorkspaces();
  }

  List<Widget> _buildContent(BuildContext context) {
    return workspaces.map((e) {
      return GestureDetector(
        onTap: () {
          widget.controller.gotoCreateRoute(workspaceEntity: e);
        },
        child: WorkspaceTile(
          workspaceEntity: e,
          isDefaultWorkspace: e.name == settingsRepo.getDefaultWorkspace(),
        ),
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
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
                  const SizedBox(height: 5),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: SizedBox(
                      height: 400,
                      child: SingleChildScrollView(
                        child: Wrap(
                          children: [
                            ..._buildContent(context),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 70.0, right: 50.0),
              child: IconButton(
                onPressed: () {
                  widget.controller.gotoCreateRoute();
                },
                icon: Icon(
                  Icons.add,
                  color: AppTheme.createNewButtonForeground,
                ),
                style: IconButton.styleFrom(
                  backgroundColor: AppTheme.createNewButtonBackground,
                  shadowColor: AppTheme.createNewButtonShadowColor,
                  foregroundColor:
                      AppTheme.createNewButtonForeground.withOpacity(0.2),
                  elevation: 10,
                ),
              ),
            ),
          ),
          bottomBar(
            text: "Manage your Fleet",
          ),
        ],
      ),
    );
  }
}
