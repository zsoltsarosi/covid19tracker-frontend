import 'dart:convert';
import 'dart:io';

import 'package:covid19tracker/model/news.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

class NewsService {
  static final NewsService _singleton = NewsService._internal();

  String _urlFeed = "http://10.0.2.2:54820/api/rssnews";

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/news.json');
  }

  factory NewsService() {
    return _singleton;
  }

  NewsService._internal();

  List<News> _parseData(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();

    return parsed.map<News>((json) => News.fromJson(json)).toList();
  }

  Future<List<News>> getData() async {
    // TODO temp to simulate delay
    await Future.delayed(new Duration(seconds: 1));

    List<News> data = <News>[];
    final response = await http.get(_urlFeed);

    if (response.statusCode == 200) {
      data = _parseData(response.body);
      print('News loaded. Updating cache.');
      await _writeFile(response.body);
      return data;
    } else {
      print('Error loading news: ${response.statusCode}. Trying fallback to cache.');

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
