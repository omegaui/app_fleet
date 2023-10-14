// ignore_for_file: avoid_print

import 'dart:io';

class AppManPage {
  AppManPage._();

  static void handleHelpContext(List<String> args) {
    bool helpFlagExists = args.contains('--help');
    bool modeFlagExists = args.contains('--mode');
    bool launcherFlagExists = args.contains('launcher');
    bool debugFlagExists = args.contains('--debug');
    if (helpFlagExists &&
        !modeFlagExists &&
        !launcherFlagExists &&
        !debugFlagExists) {
      displayUsage();
      exit(0);
    } else if (modeFlagExists && !launcherFlagExists) {
      displayModeUsage();
      exit(0);
    }
  }

  static void displayModeUsage() {
    stdout.writeln('Invalid Mode Used:');
    stdout.writeln(
        '--mode\t\tRun the app in launcher mode, accepted sub command is \'launcher\'.');
    stdout.writeln('ex: app-fleet --mode launcher');
  }

  static void displayUsage() {
    stdout.writeln('Usage: app-fleet [OPTIONS] [SUB COMMAND]\n');
    stdout.writeln('Available Options:');
    stdout.writeln(
        '--mode\t\tRun the app in launcher mode, accepted sub command is \'launcher\'.');
    stdout.writeln('--debug\t\tEnable printing debug logs to the console.');
    stdout.writeln('--help\t\tPrints this help message.');
  }
}
