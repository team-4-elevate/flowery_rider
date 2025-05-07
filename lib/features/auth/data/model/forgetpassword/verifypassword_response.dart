// features/auth/data/model/forgetpassword/verifypassword_response.dart
class VerifypasswordResponse {
  String? status;

  VerifypasswordResponse({this.status});

  factory VerifypasswordResponse.fromJson(Map<String, dynamic> json) {
    return VerifypasswordResponse(
      status: json['status'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'status': status,
      };
}
