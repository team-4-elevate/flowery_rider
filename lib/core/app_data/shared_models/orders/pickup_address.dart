class PickupAddress {
  String? address;
  String? lat;
  String? lng;

  PickupAddress toJson() => PickupAddress(address: address, lat: lat, lng: lng);
  factory PickupAddress.fromJson(Map<dynamic, dynamic> json) => PickupAddress(
      address: json['address'], lat: json['lat'], lng: json['lng']);
  PickupAddress({this.address, this.lat, this.lng});
}
