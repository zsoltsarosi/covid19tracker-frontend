import 'dart:async';
import 'dart:convert';

import 'package:covid19tracker/model/model.dart';
import 'package:covid19tracker/services/data_provider.dart';
import 'package:http/http.dart' as http;

class GeoLocationService extends DataProvider {
  static final GeoLocationService _singleton = GeoLocationService._internal();
  static String _urlIpfy;
  static String _urlGeoApi;

  factory GeoLocationService() {
    _urlIpfy = "https://api.ipify.org?format=json";
    _urlGeoApi = "https://api.ipgeolocationapi.com/geolocate/##ip##";
    return _singleton;
  }

  GeoLocationService._internal() : super(cacheThresholdInMinutes: 60 * 24 * 7, fileName: "geoloc");

  GeoLocation _parseData(String responseBody) {
    final parsed = json.decode(responseBody);
    return GeoLocation.fromJson(parsed);
  }

  Future<GeoLocation> _requestDataAndUpdateCache() async {
    print('Requesting geolocation from server.');

    http.Response response;
    try {
      response = await http.get(_urlIpfy).timeout(DataProvider.kTimeoutDuration);
      final parsed = json.decode(response.body);
      var publicIp = parsed["ip"];
      var url = _urlGeoApi.replaceFirst("##ip##", publicIp);
      response = await http.get(url).timeout(DataProvider.kTimeoutDuration);
    } on TimeoutException catch (err) {
      print('Timed out loading data.');
      throw err;
    } catch (err) {
      print('Error loading data: $err');
      throw err;
    }

    if (response.statusCode == 200) {
      var data = _parseData(response.body);
      print('geolocation loaded. Updating cache.');
      await updateCache(response.body);
      return data;
    } else {
      print('Error loading data: ${response.statusCode}.');
      throw Exception('Failed to load data');
    }
  }

  Future<GeoLocation> getGeoLocation() async {
    var cachedJson = await readFile();

    // if cached data exists
    if (cachedJson.length > 0) {
      var cacheData = parseCacheData(cachedJson);

      // update cache in background if it is too old
      if (DateTime.now().toUtc().difference(cacheData.timeStamp).inMinutes > cacheThresholdInMinutes) {
        print('Cached data too old.');
        _requestDataAndUpdateCache().catchError((e, s) => print(e));
      }

      print('Returning data from cache.');
      return _parseData(cacheData.jsonData);
    }

    // no chached data
    print('Cached data not found.');
    var data = await _requestDataAndUpdateCache().catchError((e, s) => print(e));
    return data ?? GeoLocation();
  }
}
