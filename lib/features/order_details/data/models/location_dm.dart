import 'package:equatable/equatable.dart';

class LocationDM extends Equatable {
  final double lat;
  final double lng;

  const LocationDM({
    required this.lat,
    required this.lng,
  });

  factory LocationDM.fromJson(Map<String, dynamic> json) {
    return LocationDM(
      lat: (json['lat'] as num?)?.toDouble() ?? 0.0,
      lng: (json['lng'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'lat': lat,
      'lng': lng,
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
