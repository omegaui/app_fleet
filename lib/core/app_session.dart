import 'package:app_fleet/config/theme/app_theme.dart';
import 'package:app_fleet/core/logger.dart';
import 'package:flutter/foundation.dart';

enum SessionState {
  dirty,
  clean,
}

typedef AppSessionCallback = void Function();

class AppSession {
  final List<AppSessionCallback> _listeners = [];
  final VoidCallback onRebuildRequested;

  AppSession({required this.onRebuildRequested});

  void reloadTheme() {
    AppTheme.initTheme();
    onRebuildRequested();
  }

  SessionState _state = SessionState.clean;

  bool get isClean => _state == SessionState.clean;

  void addListener(AppSessionCallback listener) {
    _listeners.add(listener);
  }

  void removeListener(AppSessionCallback listener) {
    _listeners.remove(listener);
  }

  void setSessionState(SessionState state) {
    _state = state;
    prettyLog(value: ">> Notifying ${_listeners.length} App Session Listeners");
    for (var listener in _listeners) {
      listener();
    }
  }
}
