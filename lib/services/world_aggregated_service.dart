import 'dart:async';
import 'dart:convert';

import 'package:covid19tracker/helper/app_config.dart';
import 'package:covid19tracker/model/model.dart';
import 'package:covid19tracker/services/data_provider.dart';
import 'package:http/http.dart' as http;

class WorldAggregatedService extends DataProvider {
  static final WorldAggregatedService _singleton = WorldAggregatedService._internal();
  static String _url;

  factory WorldAggregatedService() {
    _url = "${AppConfig.baseUrl}worldaggregated";
    return _singleton;
  }

  WorldAggregatedService._internal() : super(cacheThresholdInMinutes: 6 * 60, fileName: "world_aggregated");

  List<WorldAggregated> _parseData(String jsonData) {
    final parsed = json.decode(jsonData).cast<Map<String, dynamic>>();
    return parsed.map<WorldAggregated>((json) => WorldAggregated.fromJson(json)).toList();
  }

  Future<List<WorldAggregated>> _requestDataAndUpdateCache() async {
    print('Requesting data from server.');

    http.Response response;
    try {
      response = await http.get(_url).timeout(DataProvider.kTimeoutDuration);
    } on TimeoutException catch (err) {
      print('Timed out loading data.');
      throw err;
    } catch (err) {
      print('Error loading data: $err');
      throw err;
    }

    if (response.statusCode == 200) {
      var data = _parseData(response.body);
      print('Data loaded. Data points: ${data.length}. Updating cache.');
      await updateCache(response.body);
      return data;
    } else {
      print('Error loading data: ${response.statusCode}.');
      throw Exception('Failed to load data');
    }
  }

  Future<List<WorldAggregated>> getData() async {
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
    return data ?? <WorldAggregated>[];
  }
}
