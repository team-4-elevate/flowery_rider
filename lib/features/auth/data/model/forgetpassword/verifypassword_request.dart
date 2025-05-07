class VerifypasswordRequest {
  String? resetCode;

  VerifypasswordRequest({this.resetCode});

  factory VerifypasswordRequest.fromJson(Map<String, dynamic> json) {
    return VerifypasswordRequest(
      resetCode: json['resetCode'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'resetCode': resetCode,
      };
}
