import 'dart:convert';
import 'dart:io';

import 'package:covid19tracker/model/WorldAggregated.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;

class WorldAggregatedFeed {
  static final WorldAggregatedFeed _singleton = WorldAggregatedFeed._internal();

  String _url = "http://10.0.2.2:54820/api/worldaggregated";

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  // Future<File> get _localFile async {
  //   final path = await _localPath;
  //   return File('$path/world_data.json');
  // }

  factory WorldAggregatedFeed() {
    return _singleton;
  }

  WorldAggregatedFeed._internal();

  List<WorldAggregated> parseData(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();

    return parsed.map<WorldAggregated>((json) => WorldAggregated.fromJson(json)).toList();
  }

  Future<List<WorldAggregated>> getWorldData() async {
    final response = await http.get(_url);

    if (response.statusCode == 200) {
      return parseData(response.body);
    } else {
      throw Exception('Failed to load data');
    }
  }

  // Future<File> _writeFile(String jsonData) async {
  //   final file = await _localFile;
  //   return file.writeAsString(jsonData);
  // }

  // Future<String> _readFile() async {
  //   try {
  //     final file = await _localFile;
  //     String contents = await file.readAsString();
  //     return contents;
  //   } catch (e) {
  //     return "";
  //   }
  // }
}
