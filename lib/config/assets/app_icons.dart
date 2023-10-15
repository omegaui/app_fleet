import 'package:flutter/services.dart';

class AppIcons {
  AppIcons._();

  static const appFleet = 'assets/icons/app-icon.png';
  static const unknown = 'assets/icons/unknown.png';
  static const magic = 'assets/icons/magic.png';
  static const bug = 'assets/icons/bug.png';
  static const discard = 'assets/icons/discard.png';
  static const delete = 'assets/icons/delete.png';
  static const github = 'assets/icons/github.png';
  static const star = 'assets/icons/star.png';
  static const buyMeACoffee = 'assets/icons/buy-me-a-coffee.png';
  static const qrCode = 'assets/icons/qr-code.png';

  static Future<List<String>> loadPickerIcons() async {
    final assetManifest = await AssetManifest.loadFromAssetBundle(rootBundle);
    final icons = assetManifest
        .listAssets()
        .where((path) => path.startsWith("assets/icons/picker/"))
        .toList();
    return icons;
  }
}
