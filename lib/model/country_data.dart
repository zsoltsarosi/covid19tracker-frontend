
class CountryData {
  DateTime date;
  String country;
  int confirmed;
  int recovered;
  int deaths;

  CountryData({this.date, this.country, this.confirmed, this.recovered, this.deaths});

  factory CountryData.fromJson(Map<String, dynamic> json) {
    return CountryData(
      date: DateTime.parse(json['date']),
      country: json['country'] as String,
      confirmed: json['confirmed'] as int,
      recovered: json['recovered'] as int,
      deaths: json['deaths'] as int,
    );
  }
}