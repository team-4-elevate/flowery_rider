// features/apply/data/model/apply/apply_response.dart
import 'package:flowery_rider/features/apply/domain/entities/driver.dart';

class ApplyResponse {
  final bool success;
  final String message;
  final Driver? driver;
  final String? token;

  ApplyResponse({
    required this.success,
    required this.message,
    this.driver,
    this.token,
  });

  factory ApplyResponse.fromJson(Map<String, dynamic> json) {
    return ApplyResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      driver: json['driver'] != null ? Driver.fromJson(json['driver']) : null,
      token: json['token'],
    );
  }
}
