class ForgetpasswordResponse {
  String? message;
  String? info;

  ForgetpasswordResponse({this.message, this.info});

  factory ForgetpasswordResponse.fromJson(Map<String, dynamic> json) {
    return ForgetpasswordResponse(
      message: json['message'] as String?,
      info: json['info'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'message': message,
        'info': info,
      };
}
