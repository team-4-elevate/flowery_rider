class ResetpasswordResponse {
  String? message;
  String? token;

  ResetpasswordResponse({this.message, this.token});

  factory ResetpasswordResponse.fromJson(Map<String, dynamic> json) {
    return ResetpasswordResponse(
      message: json['message'] as String?,
      token: json['token'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'message': message,
        'token': token,
      };
}
