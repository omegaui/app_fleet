import 'package:app_fleet/core/app_session.dart';
import 'package:app_fleet/core/dependency_manager.dart';
import 'package:app_fleet/core/logger.dart';
import 'package:app_fleet/utils/markdown_generator.dart';
import 'package:app_fleet/utils/utils.dart';
import 'package:intl/intl.dart';
import 'package:linux_plus/linux_plus.dart';

class AppBugReport {
  AppBugReport._();

  static final AppSession _session = DependencyInjection.find<AppSession>();
  static final List<String> reportIDs = [];

  static void createZoneReport({
    required dynamic error,
    required dynamic stackTrace,
  }) {
    createReport(
      message: "Error Generated from unguarded block.",
      source: "main",
      additionalDescription: "Error caught by Zone Guard.",
      error: error,
      stackTrace: stackTrace,
    );
  }

  static void createReport({
    required String message,
    required String source,
    required String additionalDescription,
    required dynamic error,
    required dynamic stackTrace,
  }) {
    _session.setSessionState(SessionState.dirty);
    final eventTime = DateFormat("MMM dd, yyyy kk:mm").format(DateTime.now());
    MarkdownGenerator generator = MarkdownGenerator();
    generator.addHeading("Bug Report ${generator.reportID}");
    generator.addKeyPair("Distro", LinuxPlus.fullDistroName);
    generator.addKeyPair("Version", LinuxPlus.distroVersion);
    generator.addKeyPair("Parent Distro", LinuxPlus.parentDistro);
    generator.addSeparator();
    generator.addKeyPair("Time", eventTime);
    generator.addKeyPair("Area of Impact", source);
    generator.addKeyPair("Message", message);
    generator.addKeyPair("Additional Description", additionalDescription);
    generator.addKeyPair("Error", error.toString());
    generator.addCode(stackTrace.toString());
    generator.save();
    prettyLog(
        tag: "AppBugReport",
        value: "Automatic Markdown Formatted bug report has been generated at");
    prettyLog(tag: "AppBugReport", value: getBugReportPath(generator.reportID));
    prettyLog(
        tag: "AppBugReport",
        value: "Please take a step in improving App Fleet by uploading");
    prettyLog(
        tag: "AppBugReport",
        value:
            "this bug report at https://github.com/omegaui/app-fleet/issues/new");
    reportIDs.add(generator.reportID);
  }
}
