import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:monalisa_app_001/features/shared/domain/entities/response_api.dart';
import 'package:monalisa_app_001/features/shipment/domain/datasources/shipment_datasource.dart';
import 'package:monalisa_app_001/features/shipment/domain/entities/shipment.dart';

import '../../../../config/config.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../shared/shared.dart';

class ShipmentDataSourceImpl implements ShipmentDataSource {
  late final Dio dio;

  ShipmentDataSourceImpl() {
    _initDio();
  }

  Future<void> _initDio() async {
    dio = await DioClient.create();
  }

  @override
  Future<Shipment> getShipmentAndLine(
    String shipment,
    WidgetRef ref,
  ) async {
    try {
      final String url =
          "/api/v1/models/m_inout?\$expand=m_inoutline&\$filter=DocumentNo%20eq%20'${shipment.toString()}'";
      final response = await dio.get(url);

      if (response.statusCode == 200) {
        final responseApi = ResponseApi.jsonToEntity(response.data);

        if (responseApi.records != null && responseApi.records!.isNotEmpty) {
          final shipment = responseApi.records!.first;
          return shipment;
        } else {
          throw Exception('No se encontraron registros de shipment');
        }
      } else {
        throw Exception(
            'Error al cargar los datos del shipment: ${response.statusCode}');
      }
    } on DioException catch (e) {
      final authDataNotifier = ref.read(authProvider.notifier);
      throw CustomErrorDioException(e, authDataNotifier);
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
