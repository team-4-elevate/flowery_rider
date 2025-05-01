import 'package:logger/logger.dart';

class Log {
  static final Logger _logger = Logger(
    printer: PrettyPrinter(
      methodCount: 0,
      errorMethodCount: 5,
      lineLength: 50,
      colors: true,
      printEmojis: true,
    ),
  );

  Log._();

  // Simple one-word logging methods
  static void d<T>(T message) => _logger.d(message);
  static void i<T>(T message) => _logger.i(message);
  static void w<T>(T message) => _logger.w(message);
  static void e<T>(T message) => _logger.e(message);
}
