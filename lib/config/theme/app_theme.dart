import 'package:flutter/material.dart';

class AppTheme {
  static TextStyle get fontBold => const TextStyle(
        fontFamily: "Sen",
        fontWeight: FontWeight.bold,
        color: Color(0xFF1E1E1E),
      );

  static TextStyle get fontExtraBold => const TextStyle(
        fontFamily: "Sen",
        fontWeight: FontWeight.w900,
        color: Color(0xFF1E1E1E),
      );

  static TextStyle fontSize(double size) => TextStyle(
        fontFamily: "Sen",
        fontSize: size,
        color: const Color(0xFF1E1E1E),
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
