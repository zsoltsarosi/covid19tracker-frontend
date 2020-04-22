import 'dart:convert';
import 'dart:io';

import 'package:covid19tracker/model/WorldAggregated.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;

class WorldAggregatedFeed {
  static final WorldAggregatedFeed _singleton = WorldAggregatedFeed._internal();

  String _url = "http://10.0.2.2:54820/api/worldaggregated";

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/world_data.json');
  }

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

  Future<List<WorldAggregated>> getSampleData() {
    return Future.value([
      WorldAggregated(
          date: DateTime.utc(2020, 4, 4),
          confirmed: 1197408,
          recovered: 246152,
          deaths: 64606,
          increaseRate: 9.260829059134952),
      WorldAggregated(
          date: DateTime.utc(2020, 4, 5),
          confirmed: 1272115,
          recovered: 260012,
          deaths: 69374,
          increaseRate: 6.23905970229028),
      WorldAggregated(
          date: DateTime.utc(2020, 4, 6),
          confirmed: 1345101,
          recovered: 276515,
          deaths: 74565,
          increaseRate: 5.7373743725999615),
      WorldAggregated(
          date: DateTime.utc(2020, 4, 7),
          confirmed: 1426096,
          recovered: 300054,
          deaths: 81865,
          increaseRate: 6.021480914816062),
      WorldAggregated(
          date: DateTime.utc(2020, 4, 8),
          confirmed: 1511104,
          recovered: 328661,
          deaths: 88338,
          increaseRate: 5.9608890285086),
      WorldAggregated(
          date: DateTime.utc(2020, 4, 9),
          confirmed: 1595350,
          recovered: 353975,
          deaths: 95455,
          increaseRate: 5.57512917707848),
      WorldAggregated(
          date: DateTime.utc(2020, 4, 10),
          confirmed: 1691719,
          recovered: 376096,
          deaths: 102525,
          increaseRate: 6.04061804619676),
      WorldAggregated(
          date: DateTime.utc(2020, 4, 11),
          confirmed: 1771514,
          recovered: 402110,
          deaths: 108503,
          increaseRate: 4.716799894072243),
      WorldAggregated(
          date: DateTime.utc(2020, 4, 12),
          confirmed: 1846679,
          recovered: 421722,
          deaths: 114091,
          increaseRate: 4.242980862697105),
      WorldAggregated(
          date: DateTime.utc(2020, 4, 13),
          confirmed: 1917319,
          recovered: 448655,
          deaths: 119482,
          increaseRate: 3.8252452104561754),
      WorldAggregated(
          date: DateTime.utc(2020, 4, 14),
          confirmed: 1976191,
          recovered: 474261,
          deaths: 125984,
          increaseRate: 3.070537557912898),
      WorldAggregated(
          date: DateTime.utc(2020, 4, 15),
          confirmed: 2056054,
          recovered: 511019,
          deaths: 134177,
          increaseRate: 4.041259169786726),
    ]);
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
