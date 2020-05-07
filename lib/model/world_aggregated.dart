
import 'package:covid19tracker/model/single_day_data.dart';

class WorldAggregated extends SingleDayData {
  double increaseRate;

  WorldAggregated({DateTime date, int confirmed, int recovered, int deaths, this.increaseRate})
    : super(date: date, confirmed: confirmed, recovered: recovered, deaths: deaths);

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