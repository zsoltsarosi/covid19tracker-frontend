class CachedData {
  final DateTime timeStamp;
  final String jsonData;

  CachedData(this.timeStamp, this.jsonData);

  CachedData.fromJson(Map<String, dynamic> json)
      : timeStamp = DateTime.parse(json['timeStamp']),
        jsonData = json['data'];

  Map<String, dynamic> toJson() => {
        'timeStamp': timeStamp.toString(),
        'data': jsonData,
      };
}
