// core/utils/country_model.dart
class Country {
  final String isoCode;
  final String name;
  final String phoneCode;
  final String flag;
  final String currency;

  Country({
    required this.isoCode,
    required this.name,
    required this.phoneCode,
    required this.flag,
    required this.currency,
  });

  factory Country.fromJson(Map<String, dynamic> json) {
    return Country(
      isoCode: json['isoCode'] ?? '',
      name: json['name'] ?? '',
      phoneCode: json['phoneCode'] ?? '',
      flag: json['flag'] ?? '',
      currency: json['currency'] ?? '',
    );
  }

  static List<Country> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => Country.fromJson(json)).toList();
  }
}
