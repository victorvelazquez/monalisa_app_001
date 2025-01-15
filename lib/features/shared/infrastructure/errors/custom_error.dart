import 'package:dio/dio.dart';

class CustomErrorDioException implements Exception {
  final DioException e;

  CustomErrorDioException(this.e) {
    if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.connectionError) {
      throw Exception(
          'No se pudo conectar a internet. Conéctate para continuar.');
    }
    if (e.response?.statusCode == 401) {
      throw Exception(e.response?.data['message'] ??
          'Credenciales incorrectas. Vuelve a intentarlo.');
    }
    if (e.response!.statusCode == 404) {
      throw Exception(e.response?.data['message'] ??
          'Lo siento, no se encontró lo que buscabas.');
    }
    throw Exception('ERROR: ${e.message}');
  }
}

class CustomErrorClean {
  final Object obj;
  CustomErrorClean(this.obj);
  String get clean => obj.toString().startsWith('Exception: ')
      ? obj.toString().replaceFirst('Exception: ', '')
      : obj.toString();
}
