import 'dart:async';
import 'dart:convert';

import 'package:app_fleet/app/settings/data/settings_repository.dart';
import 'package:app_fleet/constants/app_meta_info.dart';
import 'package:app_fleet/constants/request_status.dart';
import 'package:app_fleet/core/app_bug_report.dart';
import 'package:app_fleet/core/dependency_manager.dart';
import 'package:app_fleet/core/storage_manager.dart';
import 'package:app_fleet/main.dart';
import 'package:app_fleet/utils/show_update_available_dialog.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:http/http.dart';

class UpdateData {
  static const noUpdates = 'No Updates';

  late String data;

  UpdateData.alreadyLatest() {
    data = noUpdates;
  }

  bool isUpdateAvailable() {
    return data != 'No Updates';
  }

  UpdateData(this.data);
}

class AppUpdater {
  final String updateDataUrl =
      'https://raw.githubusercontent.com/omegaui/app-fleet/main/updates/latest.json';

  // Stores Update Checked Status for current session
  bool _checked = false;

  StreamSubscription<ConnectivityResult> init() {
    return Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) {
      if (result != ConnectivityResult.none) {
        checkForUpdates(
          onComplete: (data, status) {
            if (status == RequestStatus.success) {
              if (data!.isUpdateAvailable()) {
                showUpdateAvailableDialog(data: data);
              }
            }
          },
        );
      }
    });
  }

  void checkForUpdates({
    required void Function(UpdateData? data, RequestStatus status) onComplete,
  }) {
    final settingsRepo = DependencyInjection.find<SettingsRepository>();
    if (debugMode || !AppStorageManager.storageReady || _checked) {
      return;
    }
    _checked = true;
    if (!settingsRepo.notifyAboutUpdates()) {
      return;
    }
    Future.delayed(const Duration(seconds: 5), () async {
      Response? response;
      try {
        response = await get(Uri.parse(updateDataUrl));
      } catch (error, stackTrace) {
        debugPrintApp('[AppUpdater] Unable to fetch update data');
        AppBugReport.createReport(
          message: "Unable to fetch update data.",
          source: "`AppUpdater` - `checkForUpdates()`",
          additionalDescription: "Possibly due to bad request or invalid url.",
          error: error,
          stackTrace: stackTrace,
        );
        return;
      }
      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        final latestVersion = body['latest'];
        if (AppMetaInfo.version != latestVersion) {
          onComplete(UpdateData(latestVersion), RequestStatus.success);
        } else {
          onComplete(UpdateData.alreadyLatest(), RequestStatus.success);
        }
      } else {
        onComplete(null, RequestStatus.failed);
        AppBugReport.createReport(
          message: "An error occurred while checking for updates.",
          source: "`AppUpdater` - `checkForUpdates()`",
          additionalDescription: "Possibly due to parse error.",
          error: Exception('Got a response code: ${response.statusCode}'),
          stackTrace: StackTrace.fromString(response.body),
        );
      }
    });
  }
}
