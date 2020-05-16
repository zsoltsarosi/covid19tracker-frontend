import 'dart:convert';
import 'dart:io';

import 'package:covid19tracker/services/cached_data.dart';
import 'package:flutter/cupertino.dart';
import 'package:path_provider/path_provider.dart';

abstract class DataProvider {

  @protected
  final int cacheThresholdInMinutes;

  @protected
  final String fileName;

  DataProvider({this.cacheThresholdInMinutes, this.fileName});

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/${this.fileName}.json');
  }

  @protected
  CachedData parseCacheData(String jsonData) {
    final parsed = jsonDecode(jsonData);
    return CachedData.fromJson(parsed);
  }

  @protected
  Future<void> updateCache(String jsonData) async {
    var data = CachedData(DateTime.now().toUtc(), jsonData);
    await _writeFile(json.encode(data));
  }

  Future<File> _writeFile(String data) async {
    final file = await _localFile;
    return file.writeAsString(data);
  }

  @protected
  Future<String> readFile() async {
    try {
      final file = await _localFile;
      return await file.readAsString();
    } catch (e) {
      return "";
    }
  }

}