import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'login_response.g.dart';

@JsonSerializable()
class LoginResponse extends Equatable {
  final String? message;
  final String? token;

  const LoginResponse({this.message, this.token});

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return _$LoginResponseFromJson(json);
  }

  Map<String, dynamic> toJson() => _$LoginResponseToJson(this);

  @override
  List<Object?> get props => [message, token];
}
