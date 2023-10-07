import 'package:flutter/material.dart';

class AppTooltipBuilder {
  static Widget wrap({text, child}) {
    if (text.isEmpty) {
      return child;
    }
    return Tooltip(
      message: text,
      waitDuration: const Duration(milliseconds: 250),
      textAlign: TextAlign.center,
      textStyle: const TextStyle(
        fontFamily: "Sen",
        fontSize: 14,
        fontWeight: FontWeight.bold,
        color: Colors.black,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.greenAccent.withOpacity(0.4),
            blurRadius: 16,
          ),
        ],
      ),
      padding: const EdgeInsets.all(10.0),
      child: child,
    );
  }
}
