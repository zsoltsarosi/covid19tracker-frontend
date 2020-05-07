
class WorldAggregated {
  DateTime date;
  int confirmed;
  int recovered;
  int deaths;
  double increaseRate;

  WorldAggregated({this.date, this.confirmed, this.recovered, this.deaths, this.increaseRate});

  factory WorldAggregated.fromJson(Map<String, dynamic> json) {
    return WorldAggregated(
      date: DateTime.parse(json['t']),
      confirmed: json['c'] as int,
      recovered: json['r'] as int,
      deaths: json['d'] as int,
      increaseRate: json['i'] as double,
    );
  }
}