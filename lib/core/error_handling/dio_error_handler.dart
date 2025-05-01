import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:injectable/injectable.dart';
import '../app_data/local_storage/local_storage_client.dart';
import '../logger/app_logger.dart';
import '../routes/navigator_observer.dart';
import '../routes/routes.dart';
import 'exceptions/api_exception.dart';

@singleton
class DioErrorHandler {
  final GlobalKey<NavigatorState> _navigatorKey;
  final LocalStorageClient _localStorage;

  DioErrorHandler(this._localStorage, this._navigatorKey);

  ApiException handle(DioException error) {
    Log.e('DioErrorHandler, handling dio error');

    if (error.response?.data != null) {
      final responseData = error.response?.data;

      String? errorMessage;
      if (responseData is Map<String, dynamic>) {
        errorMessage = responseData['error'] ?? responseData['message'];
      } else if (responseData is String) {
        errorMessage = responseData;
      }

      if (errorMessage != null) {
        _checkTokenValidity(responseData);
        return ApiException(
          message: errorMessage,
          statusCode: error.response?.statusCode,
          response: responseData,
        );
      }
    }

    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.connectionError:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return ApiException(message: 'No internet connection');
      case DioExceptionType.cancel:
        return ApiException(message: 'Request is cancelled');
      case DioExceptionType.badResponse:
        switch (error.response?.statusCode) {
          case 400:
            return ApiException(
              message: 'Bad request. Please check your input.',
              statusCode: 400,
              response: error.response?.data,
            );
          case 401:
            return ApiException(
              message: 'Unauthorized. Please try again.',
              statusCode: 401,
              response: error.response?.data,
            );
          case 403:
            return ApiException(
              message:
                  'Access denied. You don\'t have permission for this action.',
              statusCode: 403,
              response: error.response?.data,
            );
          case 404:
            return ApiException(
              message: 'Resource not found.',
              statusCode: 404,
              response: error.response?.data,
            );
          case 500:
          case 502:
          case 503:
            return ApiException(
              message: 'Server error. Please try again later.',
              statusCode: error.response?.statusCode,
              response: error.response?.data,
            );
          default:
            return ApiException(
              message: 'Server error occurred.',
              statusCode: error.response?.statusCode,
              response: error.response?.data,
            );
        }
      case DioExceptionType.unknown:
        if (error.error != null &&
            error.error.toString().contains('SocketException')) {
          return ApiException(message: 'No internet connection');
        }
        return ApiException(message: 'Network error occurred');
      default:
        return ApiException(message: 'Something went wrong');
    }
  }

  void _checkTokenValidity(data) {
    if (appCurrentRoute != Routes.login &&
        appCurrentRoute != Routes.signup &&
        data['code'] == 401 &&
        (data['message'].contains('invalid token') ||
            data['message'].contains('user not found'))) {
      Log.i('invalid token');
      _localStorage.deleteSecuredData('token')?.then(
        (_) {
          _navigatorKey.currentState
              ?.pushNamedAndRemoveUntil(Routes.login, (route) => false);
        },
      );
      return;
    }
  }
}
