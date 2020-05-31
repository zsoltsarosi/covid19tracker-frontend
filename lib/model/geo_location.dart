class GeoLocation {
  String continent;
  String countryIso2;
  String countryIso3;
  String countryName;

  GeoLocation({this.continent, this.countryIso2, this.countryIso3, this.countryName});

  factory GeoLocation.fromJson(Map<String, dynamic> json) {
    return GeoLocation(
      continent: json['continent'] as String,
      countryIso2: json['alpha2'] as String,
      countryIso3: json['alpha3'] as String,
      countryName: json['name'] as String,
    );
  }
}