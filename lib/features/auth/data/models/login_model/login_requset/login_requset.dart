import 'package:json_annotation/json_annotation.dart';

part 'login_requset.g.dart';

@JsonSerializable()
class LoginRequset {
  String? email;
  String? password;

  LoginRequset({this.email, this.password});

  factory LoginRequset.fromJson(Map<String, dynamic> json) {
    return _$LoginRequsetFromJson(json);
  }

  Map<String, dynamic> toJson() => _$LoginRequsetToJson(this);
}
