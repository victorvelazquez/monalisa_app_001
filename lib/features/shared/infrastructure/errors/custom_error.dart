import 'package:dio/dio.dart';

import '../../../auth/presentation/providers/auth_provider.dart';

class CustomErrorDioException implements Exception {
  final DioException e;
  final AuthNotifier? authNotifier;

  CustomErrorDioException(this.e, this.authNotifier) {
    if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.connectionError) {
      throw Exception(
          'No se pudo conectar a internet. Conéctate para continuar.');
    }
    if (e.response?.statusCode == 401) {
      if (e.response?.data['title'] == 'Authenticate error') {
        throw Exception(e.response?.data['message'] ??
            'Credenciales incorrectas. Vuelve a intentarlo.');
      } else if (e.response?.statusMessage == 'Unauthorized') {
        if (authNotifier == null) {
          print('AUTH NULLLLLLLLLLLLLLL');
        } else {
          print('AUTH OKKKKKKKKKKKKKKKK');
          // authNotifier?.checkAuthStatus() ?? () {};
        }
        throw Exception(
            'Sesión caducada. Por favor, inicia sesión nuevamente.');
      } else {
        throw Exception(e.response?.data['message'] ??
            'Credenciales incorrectas. Vuelve a intentarlo.');
      }
    }
    if (e.response!.statusCode == 404) {
      throw Exception(e.response?.data['message'] ??
          'Lo siento, no se encontró lo que buscabas.');
    }
    throw Exception(e.message);
  }
}

class CustomErrorClean {
  final Object obj;
  CustomErrorClean(this.obj);
  String get clean => obj.toString().startsWith('Exception: ')
      ? obj.toString().replaceFirst('Exception: ', '')
      : obj.toString();
}
