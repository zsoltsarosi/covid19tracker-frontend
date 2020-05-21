import 'dart:convert';

class AppConfig {
  static AppConfig _instance;

  String _baseUrl;
  static String get baseUrl {
    return _instance._baseUrl;
  }

  String _apiKey;
  static String get apiKey {
    return _instance._apiKey;
  }

  factory AppConfig(String configContent) {
    _instance ??= AppConfig._internal(configContent);
    return _instance;
  }

  AppConfig._internal(String configContent) {
    final json = jsonDecode(configContent);
    _baseUrl = json['baseUrl'];
    _apiKey = json['apiKey'];
  }
}
