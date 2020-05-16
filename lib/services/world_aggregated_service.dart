import 'dart:convert';
import 'dart:io';

import 'package:covid19tracker/model/model.dart';
import 'package:covid19tracker/services/cached_data.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

class WorldAggregatedService {
  static final WorldAggregatedService _singleton = WorldAggregatedService._internal();

  String _url = "http://10.0.2.2:54820/api/worldaggregated";

  int get _cacheThresholdInHours => 6;

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/world_aggregated.json');
  }

  factory WorldAggregatedService() {
    return _singleton;
  }

  WorldAggregatedService._internal();

  CachedData _parseCacheData(String jsonData) {
    final parsed = jsonDecode(jsonData);
    return CachedData.fromJson(parsed);
  }

  List<WorldAggregated> _parseData(String jsonData) {
    final parsed = json.decode(jsonData).cast<Map<String, dynamic>>();
    return parsed.map<WorldAggregated>((json) => WorldAggregated.fromJson(json)).toList();
  }

  Future<void> _updateCache(String jsonData) async {
    var data = CachedData(DateTime.now().toUtc(), jsonData);
    await _writeFile(json.encode(data));
  }

  Future<List<WorldAggregated>> _requestDataAndUpdateCache() async {
    print('Requesting new data.');
    final response = await http.get(_url);

    if (response.statusCode == 200) {
      var data = _parseData(response.body);
      print('Data loaded. Data points: ${data.length}. Updating cache.');
      await _updateCache(response.body);
      return data;
    } else {
      print('Error loading data: ${response.statusCode}.');
      throw Exception('Failed to load data');
    }
  }

  Future<List<WorldAggregated>> getData() async {
    var cachedJson = await _readFile();

    // if cached data exists
    if (cachedJson.length > 0) {
      var cacheData = _parseCacheData(cachedJson);

      // update cache in background if it is too old
      if (cacheData.timeStamp.difference(DateTime.now().toUtc()).inHours > _cacheThresholdInHours) {
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

  Future<File> _writeFile(String data) async {
    final file = await _localFile;
    return file.writeAsString(data);
  }

  Future<String> _readFile() async {
    try {
      final file = await _localFile;
      return await file.readAsString();
    } catch (e) {
      return "";
    }
  }
}
