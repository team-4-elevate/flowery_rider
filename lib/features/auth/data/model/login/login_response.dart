// features/auth/data/model/login/login_response.dart
import 'package:equatable/equatable.dart';

class LoginResponse extends Equatable {
  final String? message;
  final String? token;

  const LoginResponse({this.message, this.token});

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      message: json['message'] as String?,
      token: json['token'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'token': token,
    };
  }

  @override
  List<Object?> get props => [message, token];
}
