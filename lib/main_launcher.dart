import 'main.dart' as app_entry_point;

void main(List<String> args) {
  args = ['--mode', 'launcher', ...args];
  app_entry_point.main(args);
}
