class Country {
  final String countryCode;
  final String countryName;
  final bool citiesAvailable;

  Country({this.countryCode, this.countryName, this.citiesAvailable});

  factory Country.fromJson(Map<String, dynamic> json) {
    return Country(
      countryCode: json['countryCode'],
      countryName: json['countryName'],
      citiesAvailable: json['citiesAvailable'],
    );
  }
}
