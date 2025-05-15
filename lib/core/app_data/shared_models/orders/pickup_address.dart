class PickupAddress {
  String? address;
  int? lat;
  int? lng;

  Map<String, String?> toJson() => {
        'address': address,
        'lat': lat.toString(),
        'lng': lng.toString(),
      };
  factory PickupAddress.fromJson(Map? json) => PickupAddress(
        address: json?['address'],
        lat: json?['lat'] != null ? int.parse(json?['lat']) : null,
        lng: json?['lng'] != null ? int.parse(json?['lng']) : null,
      );
  PickupAddress({this.address, this.lat, this.lng});
}
