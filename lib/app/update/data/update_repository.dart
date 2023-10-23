import 'dart:async';

import 'package:app_fleet/core/app_updater.dart';
import 'package:app_fleet/core/dependency_manager.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart';

class UpdateRepository {
  final appUpdater = DependencyInjection.find<AppUpdater>();

  Future<StreamSubscription<List<int>>?> startUpdate({
    required UpdateData data,
    required void Function(int progress) onProgress,
    required void Function(List<int> bytes) onComplete,
    required void Function(dynamic error) onError,
    required VoidCallback onStartFailure,
  }) async {
    final response = await Client().send(Request('GET', Uri.parse(data.url)));
    final total = response.contentLength ?? 0;
    if (total == 0) {
      onStartFailure();
      return null;
    }
    final bytes = <int>[];
    var received = 0;
    return response.stream.listen((value) {
      bytes.addAll(value);
      received += value.length;
      onProgress(((received * 100) / total).round());
    })
      ..onError(onError)
      ..onDone(() {
        onComplete(bytes);
      });
  }
}
