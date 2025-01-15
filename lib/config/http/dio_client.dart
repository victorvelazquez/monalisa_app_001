import 'package:dio/dio.dart';
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

    return dio;
  }
}
