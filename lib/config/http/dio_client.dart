import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/environment.dart';
import 'dio_config.dart';

class DioClient {
  static Future<Dio> create() async {
    final dio = Dio(BaseOptions(
      baseUrl: Environment.apiUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
    ));

    final validateCertificate = Environment
        .validateCertificate; // true en producción, false en desarrollo
    await DioConfiguration.configureDio(
      dio,
      validateCertificate: validateCertificate,
      certificatePath:
          validateCertificate ? 'assets/certificates/my_certificate.pem' : null,
    );

    // Agregar interceptor para incluir el token en todas las peticiones
    dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        final prefs = await SharedPreferences.getInstance();
        final token = prefs.getString('token');
        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        options.headers['Accept'] = 'application/json';
        return handler.next(options); // continuar con la solicitud
      },
    ));

    return dio;
  }
}
