import 'dart:io';

import 'package:app_fleet/main.dart';

enum DebugType { error, info, warning, url, response, statusCode }

prettyLog({
  String? tag,
  required dynamic value,
  DebugType type = DebugType.info,
}) {
  if (!debugMode) {
    return;
  }
  switch (type) {
    case DebugType.statusCode:
      stdout.writeln(
          '\x1B[33m${"💎 STATUS CODE ${tag != null ? "$tag: " : ""}$value"}\x1B[0m');
      break;
    case DebugType.info:
      stdout.writeln(
          '\x1B[32m${"⚡ INFO ${tag != null ? "$tag: " : ""}$value"}\x1B[0m');
      break;
    case DebugType.warning:
      stdout.writeln(
          '\x1B[36m${"⚠️ Warning ${tag != null ? "$tag: " : ""}$value"}\x1B[0m');
      break;
    case DebugType.error:
      stdout.writeln(
          '\x1B[31m${"🚨 ERROR ${tag != null ? "$tag: " : ""}$value"}\x1B[0m');
      break;
    case DebugType.response:
      stdout.writeln(
          '\x1B[36m${"💡 RESPONSE ${tag != null ? "$tag: " : ""}$value"}\x1B[0m');
      break;
    case DebugType.url:
      stdout.writeln(
          '\x1B[34m${"📌 URL ${tag != null ? "$tag: " : ""}$value"}\x1B[0m');
      break;
  }
}
