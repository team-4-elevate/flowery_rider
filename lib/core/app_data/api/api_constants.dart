// core/app_data/api/api_constants.dart
class ApiConstants {
  ApiConstants._();
  static const String baseUrl = 'https://flower.elevateegy.com/api/v1/';
  static const String loginEndPoint = 'drivers/signin';
  static const String forgetPassword = 'drivers/forgotPassword';
  static const String verifyOtp = 'drivers/verifyResetCode';
  static const String resetPassword = 'drivers/resetPassword';
  static const String applyDriverEndPoint = 'drivers/apply';
  static const String homeEndPoint = 'orders/pending-orders';
  static const String pendingOrders = 'orders/driver-orders';
  static const String updateDriverProfile = 'drivers/editProfile';
  static const String uploadProfileImage = 'drivers/upload-photo';
  static const String getDriverProfile = 'drivers/profile-data';
}
