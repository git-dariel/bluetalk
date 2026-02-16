import 'package:flutter/foundation.dart';

enum AppStage { landing, permission, shell }

class AppFlowController extends ChangeNotifier {
  AppStage _stage = AppStage.landing;

  AppStage get stage => _stage;

  void startLandingFlow() {
    _stage = AppStage.permission;
    notifyListeners();
  }

  void allowAndContinue() {
    _stage = AppStage.shell;
    notifyListeners();
  }
}
