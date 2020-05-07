import 'package:covid19tracker/model/single_day_data.dart';

class CountryData extends SingleDayData {
  String country;

  CountryData({DateTime date, int confirmed, int recovered, int deaths, this.country})
      : super(date: date, confirmed: confirmed, recovered: recovered, deaths: deaths);

  factory CountryData.fromJson(Map<String, dynamic> json) {
    return CountryData(
      date: DateTime.parse(json['t']),
      country: json['n'] as String,
      confirmed: json['c'] as int,
      recovered: json['r'] as int,
      deaths: json['d'] as int,
    );
  }
}
