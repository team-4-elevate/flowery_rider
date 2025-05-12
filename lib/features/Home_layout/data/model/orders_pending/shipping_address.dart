class ShippingAddress {
  String? street;
  String? city;
  String? phone;

  ShippingAddress({this.street, this.city, this.phone});

  factory ShippingAddress.fromJson(Map<String, dynamic> json) {
    return ShippingAddress(
      street: json['street'] as String?,
      city: json['city'] as String?,
      phone: json['phone'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'street': street,
        'city': city,
        'phone': phone,
      };
}
