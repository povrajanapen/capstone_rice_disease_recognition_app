import 'package:capstone_dr_rice/models/local_language_datasource.dart';
import 'package:flutter/material.dart';

// Language provider for state management
class LanguageProvider with ChangeNotifier {
  String _languageCode = 'en';
  String get languageCode => _languageCode;
  final _localizations = AppLocalizations();
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  LanguageProvider() {
    _loadLanguage(_languageCode); // Load initial language
  }

  Future<void> _loadLanguage(String code) async {
    _isLoading = true;
    notifyListeners();
    await _localizations.load(code);
    _isLoading = false;
    notifyListeners();
  }

  void setLanguage(String code) {
    if (_languageCode != code) {
      _languageCode = code;
      _loadLanguage(_languageCode);
    }
  }

  String translate(String key) {
    return _localizations.translate(key);
  }
}