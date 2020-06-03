import 'dart:async';
import 'dart:convert';

import 'package:covid19tracker/helper/app_config.dart';
import 'package:http/http.dart' as http;
import 'package:package_info/package_info.dart';

class VersionUpdateService {
  static final VersionUpdateService _singleton = VersionUpdateService._internal();
  static const String kHeaderApiKey = 'X-Api-Key';
  static Duration kTimeoutDuration = Duration(seconds: 10);
  static int kExpirationThresholdInDays = 14;
  static String _url;

  factory VersionUpdateService() {
    _url = "${AppConfig.baseUrl}versionupdate?version=##version##";
    return _singleton;
  }

  VersionUpdateService._internal();

  DateTime _parseData(String responseBody) {
    if (responseBody.isEmpty) return null;
    final parsed = json.decode(responseBody);
    return DateTime.parse(parsed);
  }

  Future<PackageInfo> _readVersionInfo() async {
    return await PackageInfo.fromPlatform();
  }

  Future<DateTime> _getExpirationDate() async {
    var versionInfo = await _readVersionInfo();
    print('Checking version ${versionInfo.version} expiration');

    http.Response response;
    try {
      var headers = {kHeaderApiKey: AppConfig.apiKey};
      var url = _url.replaceFirst("##version##", versionInfo.version);
      response = await http.get(url, headers: headers).timeout(kTimeoutDuration);
    } on TimeoutException catch (err) {
      print('Timed out loading data.');
      throw err;
    } catch (err) {
      print('Error loading data: $err');
      throw err;
    }

    if (response.statusCode == 204) {
      // no content
      return null;
    }
    else if (response.statusCode == 200) {
      var date = _parseData(response.body);
      return date;
    } else {
      throw Exception('Failed to check expiration.');
    }
  }

  Future<VersionExpiration> checkExpired() async {
    var expiration = await _getExpirationDate();
    if (expiration == null) return VersionExpiration.NotExpired;

    var now = DateTime.now().toUtc();
    if (expiration.isBefore(now)) {
      return VersionExpiration.Expired;
    }

    if (expiration.difference(now).inDays < kExpirationThresholdInDays) {
      return VersionExpiration.ExiresSoon;
    }

    return VersionExpiration.NotExpired;
  }
}

enum VersionExpiration { NotExpired, ExiresSoon, Expired }
