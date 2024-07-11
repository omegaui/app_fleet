import 'package:app_fleet/app/settings/data/settings_repository.dart';
import 'package:app_fleet/core/dependency_manager.dart';
import 'package:app_fleet/core/json_configurator.dart';
import 'package:app_fleet/core/logger.dart';
import 'package:app_fleet/utils/utils.dart';
import 'package:flutter/material.dart';

class AppTheme {
  AppTheme._();

  static JsonConfigurator _theme =
      JsonConfigurator(configName: combinePath(['themes', 'light.json']));

  static Color background = Colors.white;
  static Color foreground = const Color(0xFF1E1E1E);
  static Color windowDropShadow = const Color(0x66607D8B);
  static Color dialogDropShadow = const Color(0x669E9E9E);
  static Color createButtonBorderColor = const Color(0xFF448AFF);
  static Color createButtonBackground = const Color(0x33448AFF);
  static Color createButtonForeground = const Color(0xFF2196F3);
  static Color createNewButtonBackground = const Color(0xFF2196F3);
  static Color createNewButtonForeground = Colors.white;
  static Color createNewButtonShadowColor = Colors.white;
  static Color infoIconColor = Colors.black;
  static Color settingsIconColor = const Color(0xFF424242);
  static Color workspaceTileColor = Colors.white;
  static Color floatingAppTileColor = Colors.white;
  static Color floatingAppTileDropShadowColor = const Color(0xCC9E9E9E);
  static Color switchColor = const Color(0xFF6750A4);
  static Color negativeOptionBackground = const Color(0x33F44336);
  static Color negativeOptionForeground = const Color(0xFFFF5252);
  static Color recommendedOptionBackground = const Color(0x1A4CAF50);
  static Color recommendedOptionForeground = const Color(0xFF00C853);
  static Color safeOptionBackground = const Color(0x332196F3);
  static Color safeOptionForeground = const Color(0xFF448AFF);
  static Color addAppButtonBackground = const Color(0x3369F0AE);
  static Color addAppButtonForeground = Colors.black;
  static Color selectAppButtonBackground = const Color(0x33448AFF);
  static Color selectAppButtonForeground = Colors.black;
  static Color removeAppsButtonBackground = const Color(0x33FF5252);
  static Color removeAppsButtonForeground = Colors.black;
  static Color appTileForeground = Colors.white;
  static Color appTileBackground = const Color(0xFF9E9E9E);
  static Color appWorkspaceIndicatorForeground = Colors.white;
  static Color appWorkspaceIndicatorBackground = const Color(0xFF388E3C);
  static Color selectedWorkspaceIndicatorForeground = Colors.white;
  static Color selectedWorkspaceIndicatorBackground = const Color(0xFF388E3C);
  static Color unselectedWorkspaceIndicatorForeground = Colors.white;
  static Color unselectedWorkspaceIndicatorBackground = const Color(0xFF00C853);
  static Color workspaceDialogBackground = const Color(0xFFB9F6CA);
  static Color workspaceDialogDropShadowColor = const Color(0x669E9E9E);
  static Color configLabelForeground = const Color(0xFF424242);
  static Color configLabelBackground = const Color(0x339E9E9E);
  static Color saveLabelBackground = const Color(0xFF448AFF);
  static Color saveLabelForeground = Colors.white;
  static Color cancelLabelBackground = const Color(0xFFFF5252);
  static Color cancelLabelForeground = Colors.white;
  static Color fieldEnabledColor = const Color(0xFF9E9E9E);
  static Color fieldDisabledColor = Colors.white;
  static Color fieldFocusedColor = const Color(0xFF4CAF50);
  static Color fieldPrimaryColor = const Color(0xFF2196F3);

  static bool _darkMode = false;

  static bool isLightMode() {
    return !_darkMode;
  }

  static bool isDarkMode() {
    return _darkMode;
  }

  static void initTheme() {
    _darkMode = false;
    final settings = DependencyInjection.find<SettingsRepository>();
    final userPreferred = settings.getThemeMode();
    if (userPreferred == 'system') {
      final systemTheme = getSystemTheme();
      _darkMode = systemTheme == 'dark';
    } else {
      _darkMode = userPreferred == 'dark';
    }
    if (_darkMode) {
      _theme =
          JsonConfigurator(configName: combinePath(['themes', 'dark.json']));
    } else if (_theme.configName.endsWith('dark.json')) {
      _theme =
          JsonConfigurator(configName: combinePath(['themes', 'light.json']));
    }
    background = _theme.getColor('background');
    foreground = _theme.getColor('foreground');
    windowDropShadow = _theme.getColor('window-drop-shadow');
    dialogDropShadow = _theme.getColor('dialog-drop-shadow');
    createButtonBorderColor = _theme.getColor('create-button-border-color');
    createButtonBackground = _theme.getColor('create-button-background');
    createButtonForeground = _theme.getColor('create-button-foreground');
    createNewButtonBackground = _theme.getColor('create-new-button-background');
    createNewButtonForeground = _theme.getColor('create-new-button-foreground');
    createNewButtonShadowColor =
        _theme.getColor('create-new-button-shadow-color');
    infoIconColor = _theme.getColor('info-icon-color');
    settingsIconColor = _theme.getColor('settings-icon-color');
    workspaceTileColor = _theme.getColor('workspace-tile-color');
    floatingAppTileColor = _theme.getColor('floating-app-tile-color');
    floatingAppTileDropShadowColor =
        _theme.getColor('floating-app-tile-drop-shadow-color');
    switchColor = _theme.getColor('switch-color');
    negativeOptionBackground = _theme.getColor('negative-option-background');
    negativeOptionForeground = _theme.getColor('negative-option-foreground');
    recommendedOptionBackground =
        _theme.getColor('recommended-option-background');
    recommendedOptionForeground =
        _theme.getColor('recommended-option-foreground');
    safeOptionBackground = _theme.getColor('safe-option-background');
    safeOptionForeground = _theme.getColor('safe-option-foreground');
    addAppButtonBackground = _theme.getColor('add-app-button-background');
    addAppButtonForeground = _theme.getColor('add-app-button-foreground');
    selectAppButtonBackground = _theme.getColor('select-app-button-background');
    selectAppButtonForeground = _theme.getColor('select-app-button-foreground');
    removeAppsButtonBackground =
        _theme.getColor('remove-apps-button-background');
    removeAppsButtonForeground =
        _theme.getColor('remove-apps-button-foreground');
    appTileForeground = _theme.getColor('app-tile-foreground');
    appTileBackground = _theme.getColor('app-tile-background');
    appWorkspaceIndicatorForeground =
        _theme.getColor('app-workspace-indicator-foreground');
    appWorkspaceIndicatorBackground =
        _theme.getColor('app-workspace-indicator-background');
    selectedWorkspaceIndicatorForeground =
        _theme.getColor('selected-workspace-indicator-foreground');
    selectedWorkspaceIndicatorBackground =
        _theme.getColor('selected-workspace-indicator-background');
    unselectedWorkspaceIndicatorForeground =
        _theme.getColor('unselected-workspace-indicator-foreground');
    unselectedWorkspaceIndicatorBackground =
        _theme.getColor('unselected-workspace-indicator-background');
    workspaceDialogBackground = _theme.getColor('workspace-dialog-background');
    workspaceDialogDropShadowColor =
        _theme.getColor('workspace-dialog-drop-shadow-color');
    configLabelForeground = _theme.getColor('config-label-foreground');
    configLabelBackground = _theme.getColor('config-label-background');
    saveLabelBackground = _theme.getColor('save-label-background');
    saveLabelForeground = _theme.getColor('save-label-foreground');
    cancelLabelBackground = _theme.getColor('cancel-label-background');
    cancelLabelForeground = _theme.getColor('cancel-label-foreground');
    fieldEnabledColor = _theme.getColor('field-enabled-color');
    fieldDisabledColor = _theme.getColor('field-disabled-color');
    fieldFocusedColor = _theme.getColor('field-focused-color');
    fieldPrimaryColor = _theme.getColor('field-primary-color');
    prettyLog(
        tag: "AppTheme",
        value: "${_darkMode ? 'Dark' : 'Light'} Mode applied ...");
  }

  static TextStyle get fontBold => TextStyle(
        fontFamily: "Sen",
        fontWeight: FontWeight.bold,
        color: foreground,
      );

  static TextStyle get fontExtraBold => TextStyle(
        fontFamily: "Sen",
        fontWeight: FontWeight.w900,
        color: foreground,
      );

  static TextStyle fontSize(double size) => TextStyle(
        fontFamily: "Sen",
        fontSize: size,
        color: foreground,
      );
}

extension ConfigurableTextStyle on TextStyle {
  TextStyle withColor(Color color) {
    return copyWith(
      color: color,
    );
  }

  TextStyle makeBold() {
    return copyWith(
      fontWeight: FontWeight.bold,
    );
  }

  TextStyle makeMedium() {
    return copyWith(
      fontWeight: FontWeight.w500,
    );
  }

  TextStyle makeItalic() {
    return copyWith(
      fontStyle: FontStyle.italic,
    );
  }

  TextStyle makeExtraBold() {
    return copyWith(
      fontWeight: FontWeight.w900,
    );
  }

  TextStyle fontSize(double size) {
    return copyWith(
      fontSize: size,
    );
  }
}

extension ThemeConfigurator on JsonConfigurator {
  Color getColor(key) {
    return HexColor.from(get(key));
  }
}

extension HexColor on Color {
  static Color from(String hexColor) {
    hexColor = hexColor.replaceAll("0x", "");
    hexColor = hexColor.replaceAll("#", "");
    hexColor = hexColor.toUpperCase();
    if (hexColor.length == 6) {
      hexColor = "FF$hexColor";
    }
    return Color(int.parse(hexColor, radix: 16));
  }
}
