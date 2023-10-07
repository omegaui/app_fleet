import 'main_launcher.dart' as launcher_entry_point;

void main(List<String> args) {
  args = ['--debug', ...args];
  launcher_entry_point.main(args);
}
