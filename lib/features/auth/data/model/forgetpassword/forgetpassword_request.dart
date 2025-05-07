class ForgetpasswordRequest {
  String? email;

  ForgetpasswordRequest({this.email});

  factory ForgetpasswordRequest.fromJson(Map<String, dynamic> json) {
    return ForgetpasswordRequest(
      email: json['email'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'email': email,
      };
}
