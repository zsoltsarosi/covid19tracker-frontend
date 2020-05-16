import 'dart:convert';

import 'package:covid19tracker/model/model.dart';
import 'package:covid19tracker/services/data_provider.dart';
import 'package:http/http.dart' as http;

class CountryDataService extends DataProvider {
  static final CountryDataService _singleton = CountryDataService._internal();

  String _url = "http://10.0.2.2:54820/api/countrydata";
  String _urlDetail = "http://10.0.2.2:54820/api/countrydata/##country##";

  factory CountryDataService() {
    return _singleton;
  }

  CountryDataService._internal() : super(cacheThresholdInMinutes: 6 * 60, fileName: "country_data");

  List<CountryData> _parseData(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();

    return parsed.map<CountryData>((json) => CountryData.fromJson(json)).toList();
  }

  Future<List<CountryData>> _requestDataAndUpdateCache() async {
    print('Requesting data from server.');
    final response = await http.get(_url);

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

  Future<List<CountryData>> getData([String filter]) async {
    var cachedJson = await readFile();

    // if cached data exists
    if (cachedJson.length > 0) {
      var cacheData = parseCacheData(cachedJson);

      // update cache in background if it is too old
      if (cacheData.timeStamp.difference(DateTime.now().toUtc()).inMinutes > cacheThresholdInMinutes) {
        print('Cached data too old.');
        _requestDataAndUpdateCache().catchError((e, s) => print(e));
      }

      print('Returning data from cache.');
      var data = _parseData(cacheData.jsonData);
      return _filteredData(data, filter);
    }

    // no chached data
    print('Cached data not found.');
    var data = await _requestDataAndUpdateCache().catchError((e, s) => print(e));
    return _filteredData(data, filter);
  }

  List<CountryData> _filteredData(List<CountryData> data, String filter) {
    if (data == null) return <CountryData>[];
    if (filter == null || filter.trim().isEmpty) return data;

    filter = filter.trim().toLowerCase();
    var result = data.where((country) => country.country.toLowerCase().contains(filter)).toList();
    return result;
  }

  Future<List<CountryData>> getDetail(String country) async {
    List<CountryData> data = <CountryData>[];
    final response = await http.get(_urlDetail.replaceFirst("##country##", country));

    if (response.statusCode == 200) {
      data = _parseData(response.body);
      print('Country detail loaded. Data points: ${data.length}.');
      return data;
    } else {
      print('Error loading data: ${response.statusCode}.');
      throw Exception('Failed to load data');
    }
  }
}
