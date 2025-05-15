import 'package:equatable/equatable.dart';

class LocationDM extends Equatable {
  final double lat;
  final double lng;

  const LocationDM({
    required this.lat,
    required this.lng,
  });

  factory LocationDM.fromJson(Map json) {
    return LocationDM(
      lat: double.parse(json['lat'] ?? '0'),
      lng: double.parse(json['lng'] ?? '0'),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'lat': lat.toString(),
      'lng': lng.toString(),
    };
  }

  LocationDM copyWith({
    double? lat,
    double? lng,
  }) {
    return LocationDM(
      lat: lat ?? this.lat,
      lng: lng ?? this.lng,
    );
  }

  @override
  List<Object?> get props => [lat, lng];
}
