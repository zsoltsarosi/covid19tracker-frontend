
class CountryData {
  DateTime date;
  String country;
  int confirmed;
  int recovered;
  int deaths;

  CountryData({this.date, this.country, this.confirmed, this.recovered, this.deaths});

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