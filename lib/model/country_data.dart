import 'package:covid19tracker/model/single_day_data.dart';

class CountryData extends SingleDayData {
  String country;
  String countryIso2;
  double latitude, longitude;

  CountryData({DateTime date, int confirmed, int recovered, int deaths, 
      this.country, this.countryIso2, this.latitude, this.longitude})
      : super(date: date, confirmed: confirmed, recovered: recovered, deaths: deaths);

  factory CountryData.fromJson(Map<String, dynamic> json) {
    return CountryData(
      date: DateTime.parse(json['t']),
      country: json['n'] as String,
      countryIso2: json['n2'] as String,
      confirmed: json['c'] as int,
      recovered: json['r'] as int,
      deaths: json['d'] as int,
      latitude: json['lat'].toDouble(),
      longitude: json['lon'].toDouble(),
    );
  }
}
