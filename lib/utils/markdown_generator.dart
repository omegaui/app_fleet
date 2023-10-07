import 'dart:io';
import 'dart:math';

import 'package:app_fleet/utils/utils.dart';

final _random = Random();
final _numberList = List.generate(10, (index) => index);
final _alphabetList = [
  'A',
  'B',
  'C',
  'D',
  'E',
  'F',
  'G',
  'H',
  'I',
  'J',
  'K',
  'L',
  'M',
  'N',
  'O',
  'P',
  'Q',
  'R',
  'S',
  'T',
  'U',
  'V',
  'W',
  'X',
  'Y',
  'Z'
];

class MarkdownGenerator {
  late String _text;
  late String reportID;

  MarkdownGenerator() {
    _text = "";
    reportID = _getUniqueReportID();
  }

  void addLine(String line) {
    _text = "$_text$line\n";
  }

  void addCode(String line) {
    _text = "$_text```shell\n$line```\n";
  }

  void addHeading(String heading) {
    _text = "$_text\n# $heading\n\n";
  }

  void addKeyPair(String key, String pair) {
    _text = "$_text**$key**: $pair\n";
  }

  void addSeparator() {
    _text += "\n";
  }

  void save() {
    File(combinePath(
      [
        ".config",
        "bug-reports",
        "$reportID.md",
      ],
    )).writeAsStringSync(_text, flush: true);
  }

  String _getUniqueReportID() {
    final n1 = _random.nextInt(10);
    final n2 = _random.nextInt(10);
    final n3 = _random.nextInt(10);
    final a1 = _random.nextInt(26);
    return "${_alphabetList[a1]}-${_numberList[n1]}${_numberList[n2]}${_numberList[n3]}";
  }
}
