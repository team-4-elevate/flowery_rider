class Store {
  String? name;
  String? image;
  String? address;
  String? phoneNumber;
  String? latLong;

  Store({
    this.name,
    this.image,
    this.address,
    this.phoneNumber,
    this.latLong,
  });

  factory Store.fromJson(Map<String, dynamic> json) => Store(
        name: json['name'] as String?,
        image: json['image'] as String?,
        address: json['address'] as String?,
        phoneNumber: json['phoneNumber'] as String?,
        latLong: json['latLong'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'name': name,
        'image': image,
        'address': address,
        'phoneNumber': phoneNumber,
        'latLong': latLong,
      };
}
