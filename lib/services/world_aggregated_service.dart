import 'dart:convert';
import 'dart:io';

import 'package:covid19tracker/model/world_aggregated.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

class WorldAggregatedService {
  static final WorldAggregatedService _singleton = WorldAggregatedService._internal();

  String _url = "http://10.0.2.2:54820/api/worldaggregated";

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

  List<WorldAggregated> _parseData(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();

    return parsed.map<WorldAggregated>((json) => WorldAggregated.fromJson(json)).toList();
  }

  Future<List<WorldAggregated>> getData() async {
    List<WorldAggregated> data = <WorldAggregated>[];
    final response = await http.get(_url);

    if (response.statusCode == 200) {
      data = _parseData(response.body);
      print('Data loaded. Data points: ${data.length}. Updating cache.');
      await _writeFile(response.body);
      return data;
    } else {
      print('Error loading data: ${response.statusCode}. Trying fallback to cache.');

      // trying to get cached data
      var cachedJson = await _readFile();
      if (cachedJson.length > 0) {
        data = _parseData(cachedJson);
        return data;
      }

      throw Exception('Failed to load data');
    }
  }

  Future<File> _writeFile(String jsonData) async {
    final file = await _localFile;
    return file.writeAsString(jsonData);
  }

  Future<String> _readFile() async {
    try {
      final file = await _localFile;
      String contents = await file.readAsString();
      return contents;
    } catch (e) {
      return "";
    }
  }
}
