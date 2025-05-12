import 'driver.dart';

class Profile {
  String? message;
  Driver? driver;

  Profile({this.message, this.driver});

  factory Profile.fromJson(Map<String, dynamic> json) => Profile(
        message: json['message'] as String?,
        driver: json['driver'] == null
            ? null
            : Driver.fromJson(json['driver'] as Map<String, dynamic>),
      );

  Map<String, dynamic> toJson() => {
        'message': message,
        'driver': driver?.toJson(),
      };
}
