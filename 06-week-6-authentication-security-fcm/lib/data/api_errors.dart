import 'package:dio/dio.dart';

String mapApiError(Object error) {
  if (error is DioException) {
    final code = error.response?.statusCode;
    if (code == 401) {
      return 'Sesi kedaluwarsa (401). Silakan masuk kembali.';
    }
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return 'Koneksi ke server kampus timeout. Coba lagi.';
      case DioExceptionType.connectionError:
        return 'Perangkat sedang offline. Periksa koneksi internet Anda.';
      default:
        return 'Kesalahan jaringan (${code ?? error.type.name}).';
    }
  }
  return error.toString().replaceFirst('Exception: ', '');
}
