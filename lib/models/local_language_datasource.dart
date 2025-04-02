import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

class AppLocalizations {
  Map<String, String> _localizedStrings = {};

  Future<void> load(String languageCode) async {
    try {
      String jsonString = await rootBundle.loadString('assets/data/$languageCode.json');
      Map<String, dynamic> jsonMap = json.decode(jsonString);
      _localizedStrings = jsonMap.map((key, value) => MapEntry(key, value.toString()));
    } catch (e) {
      _localizedStrings = {};
      print('Error loading language $languageCode: $e');
    }
  }

  String translate(String key) {
    return _localizedStrings[key] ?? key;
  }
}