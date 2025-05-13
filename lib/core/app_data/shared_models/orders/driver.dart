class FirebaseDriverDM {
  final String id;
  final String name;
  final String phone;
  final String email;
  final String? photo;

  FirebaseDriverDM(
      {required this.id,
      required this.name,
      required this.phone,
      required this.email,
      this.photo});

  Map<String, dynamic> toJson() =>
      {'id': id, 'name': name, 'phone': phone, 'email': email, 'photo': photo};
  factory FirebaseDriverDM.fromJson(Map<String, dynamic> json) {
    return FirebaseDriverDM(
      id: json['id'],
      name: json['name'],
      phone: json['phone'],
      email: json['email'],
      photo: json['photo'],
    );
  }
}
