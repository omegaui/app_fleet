import 'package:flutter/services.dart';

class AppIcons {
  AppIcons._();

  static const appFleet = 'assets/icons/app-icon.png';
  static const unknown = 'assets/icons/unknown.png';
  static const magic = 'assets/icons/magic.png';
  static const bug = 'assets/icons/bug.png';
  static const discard = 'assets/icons/discard.png';
  static const delete = 'assets/icons/delete.png';

  static Future<List<String>> loadPickerIcons() async {
    final assetManifest = await AssetManifest.loadFromAssetBundle(rootBundle);
    final icons = assetManifest
        .listAssets()
        .where((path) => path.startsWith("assets/icons/picker/"))
        .toList();
    return icons;
  }
}
