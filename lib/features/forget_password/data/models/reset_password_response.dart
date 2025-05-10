class ResetPasswordResponseModel {
  final String? message;
  final String? token;

  const ResetPasswordResponseModel({this.message, this.token});

  factory ResetPasswordResponseModel.fromJson(Map<String, dynamic> json) {
    return ResetPasswordResponseModel(
      message: json['message'] as String?,
      token: json['token'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'message': message,
        'token': token,
      };
}
