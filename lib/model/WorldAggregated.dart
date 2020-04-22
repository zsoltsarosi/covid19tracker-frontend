
class WorldAggregated {
  DateTime date;
  int confirmed;
  int recovered;
  int deaths;
  double increaseRate;

  WorldAggregated({this.date, this.confirmed, this.recovered, this.deaths, this.increaseRate});

  factory WorldAggregated.fromJson(Map<String, dynamic> json) {
    return WorldAggregated(
      date: DateTime.parse(json['date']),
      confirmed: json['confirmed'] as int,
      recovered: json['recovered'] as int,
      deaths: json['deaths'] as int,
      increaseRate: json['increaseRate'] as double,
    );
  }
}