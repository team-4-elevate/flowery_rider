import 'app_exception.dart';

class NetworkException extends AppException {
  NetworkException(super.message);
  @override
  String toString() {
    return message;
  }
}
