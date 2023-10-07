import 'main.dart' as app_entry_point;

void main(List<String> args) {
  args = ['--debug', ...args];
  app_entry_point.main(args);
}
