// features/order_details/data/models/location_dm.dart
import 'package:equatable/equatable.dart';

class LocationDM extends Equatable {
  final double lat;
  final double lng;

  const LocationDM({
    required this.lat,
    required this.lng,
  });

  factory LocationDM.fromJson(Map json) {
    double parseSafeDouble(dynamic value) {
      if (value == null) return 0.0;
      if (value is num) return value.toDouble();
      if (value is String) {
        try {
          return double.parse(value);
        } catch (_) {
          return 0.0;
        }
      }
      return 0.0;
    }

    return LocationDM(
      lat: parseSafeDouble(json['lat']),
      lng: parseSafeDouble(json['lng']),
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
