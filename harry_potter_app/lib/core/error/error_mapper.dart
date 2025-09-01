import 'package:dio/dio.dart';

String mapErrorToKey(Object error) {
  if (error is DioException) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return 'error_timeout';
      case DioExceptionType.connectionError:
        return 'error_offline';
      case DioExceptionType.badResponse:
        final code = error.response?.statusCode ?? 0;
        if (code == 404) return 'error_not_found';
        if (code >= 500) return 'error_server';
        return 'error_generic';
      case DioExceptionType.cancel:
        return 'error_generic';
      case DioExceptionType.badCertificate:
        return 'error_generic';
      case DioExceptionType.unknown:
        return 'error_generic';
    }
  }
  return 'error_generic';
}
