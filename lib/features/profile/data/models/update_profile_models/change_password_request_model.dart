class ChangePasswordRequestModel {
  String oldPassword;
  String newPassword;
  // String confirmPassword;
  ChangePasswordRequestModel({
    required this.oldPassword,
    required this.newPassword,
    // required this.confirmPassword,
  });
  Map<String, dynamic> toJson() {
    return {
      // 'confirmPassword': confirmPassword, // api does not support this field
      'password': oldPassword,
      'newPassword': newPassword,
    };
  }
}
