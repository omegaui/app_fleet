import 'package:app_fleet/main.dart';

enum SessionState {
  dirty,
  clean,
}

typedef AppSessionCallback = void Function();

class AppSession {
  final List<AppSessionCallback> _listeners = [];

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
    debugPrintApp(">> Notifying ${_listeners.length} App Session Listeners");
    for (var listener in _listeners) {
      listener();
    }
  }
}
