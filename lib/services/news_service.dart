import 'dart:async';
import 'dart:convert';

import 'package:covid19tracker/model/model.dart';
import 'package:covid19tracker/services/data_provider.dart';
import 'package:http/http.dart' as http;

class NewsService extends DataProvider {
  static final NewsService _singleton = NewsService._internal();

  String _url = "http://10.0.2.2:54820/api/rssnews";

  factory NewsService() {
    return _singleton;
  }

  NewsService._internal() : super(cacheThresholdInMinutes: 15, fileName: "news");

  List<News> _parseData(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();

    return parsed.map<News>((json) => News.fromJson(json)).toList();
  }

  Future<List<News>> _requestDataAndUpdateCache() async {
    print('Requesting news from server.');

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
      print('News loaded. Updating cache.');
      await updateCache(response.body);
      return data;
    } else {
      print('Error loading data: ${response.statusCode}.');
      throw Exception('Failed to load data');
    }
  }

  Future<List<News>> getData() async {
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
    return data ?? <News>[];
  }
}
