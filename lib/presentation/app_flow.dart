import 'package:flutter/material.dart';

import '../infrastructure/nearby/connectivity_permission_service.dart';
import '../infrastructure/nearby/nearby_connections_chat_service.dart';
import 'controllers/app_flow_controller.dart';
import 'controllers/shell_controller.dart';
import 'design/app_theme.dart';
import 'screens/landing_screen.dart';
import 'screens/main_shell_screen.dart';
import 'screens/permission_screen.dart';

ThemeData blueTalkTheme() => buildBlueTalkTheme();

class BlueTalkFlow extends StatefulWidget {
  const BlueTalkFlow({super.key});

  @override
  State<BlueTalkFlow> createState() => _BlueTalkFlowState();
}

class _BlueTalkFlowState extends State<BlueTalkFlow> {
  final AppFlowController _flowController = AppFlowController();
  final ConnectivityPermissionService _permissionService =
      ConnectivityPermissionService();

  late final NearbyConnectionsChatService _chatService =
      NearbyConnectionsChatService(username: 'BlueTalk User');

  late final ShellController _shellController = ShellController(
    permissionService: _permissionService,
    chatService: _chatService,
  );

  @override
  void dispose() {
    _flowController.dispose();
    _shellController.dispose();
    super.dispose();
  }

  Future<void> _handleAllowAndContinue() async {
    final bool ready = await _shellController.requestPermissionAndStart();
    if (!mounted || !ready) {
      return;
    }
    _flowController.allowAndContinue();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _flowController,
      builder: (BuildContext context, _) {
        return switch (_flowController.stage) {
          AppStage.landing =>
            LandingScreen(onStart: _flowController.startLandingFlow),
          AppStage.permission => PermissionScreen(
              onContinue: _handleAllowAndContinue,
            ),
          AppStage.shell => MainShellScreen(controller: _shellController),
        };
      },
    );
  }
}
