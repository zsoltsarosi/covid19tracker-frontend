import 'dart:convert';
import 'dart:io';

import 'package:covid19tracker/model/country_data.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

class CountryDataService {
  static final CountryDataService _singleton = CountryDataService._internal();

  String _url = "http://10.0.2.2:54820/api/countrydata";

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/country_data.json');
  }

  factory CountryDataService() {
    return _singleton;
  }

  CountryDataService._internal();

  List<CountryData> _parseData(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    
    return parsed.map<CountryData>((json) => CountryData.fromJson(json)).toList();
  }

  Future<List<CountryData>> getData() async {
    List<CountryData> data = <CountryData>[];
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
