import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:monalisa_app_001/features/shared/domain/entities/response_api.dart';
import 'package:monalisa_app_001/features/m_inout/domain/datasources/m_inout_datasource.dart';
import 'package:monalisa_app_001/features/m_inout/domain/entities/m_in_out.dart';
import 'package:monalisa_app_001/features/shared/domain/entities/standard_response.dart';

import '../../../../config/config.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../shared/domain/entities/ad_login_request.dart';
import '../../../shared/domain/entities/model_set_doc_action.dart';
import '../../../shared/domain/entities/model_set_doc_action_request.dart';
import '../../../shared/shared.dart';
import '../../domain/entities/m_in_out_confirm.dart';

class MInOutDataSourceImpl implements MInOutDataSource {
  late final Dio dio;
  late final Future<void> _dioInitialized;

  MInOutDataSourceImpl() {
    _dioInitialized = _initDio();
  }

  Future<void> _initDio() async {
    dio = await DioClient.create();
  }

  @override
  Future<List<MInOut>> getMInOutList(bool isSOTrx, WidgetRef ref) async {
    await _dioInitialized;
    final String title = isSOTrx ? 'Shipment' : 'Material Receipt';
    final int warehouseID = ref.read(authProvider).selectedWarehouse!.id;

    try {
      final String url =
          "/api/v1/models/m_inout?\$filter=IsSOTrx%20eq%20$isSOTrx%20AND%20M_Warehouse_ID%20eq%20$warehouseID%20AND%20(DocStatus%20eq%20'DR'%20OR%20DocStatus%20eq%20'IP')";

      final response = await dio.get(url);

      if (response.statusCode == 200) {
        final responseApi = ResponseApi<MInOut>.fromJson(response.data, MInOut.fromJson);

        if (responseApi.records != null && responseApi.records!.isNotEmpty) {
          final mInOutList = responseApi.records!;
          return mInOutList;
        } else {
          return [];
        }
      } else {
        throw Exception(
            'Error al obtener la lista de $title: ${response.statusCode}');
      }
    } on DioException catch (e) {
      final authDataNotifier = ref.read(authProvider.notifier);
      throw CustomErrorDioException(e, authDataNotifier);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<List<MInOutConfirm>> getMInOutConfirmList(
      int mInOutId, bool isSOTrx, WidgetRef ref) async {
    await _dioInitialized;
    final String title = isSOTrx ? 'Shipment' : 'Material Receipt';

    try {
      final String url =
          "/api/v1/models/m_inoutConfirm?\$filter=M_InOut_ID%20eq%20$mInOutId";

      final response = await dio.get(url);

      if (response.statusCode == 200) {
        final responseApi = ResponseApi<MInOutConfirm>.fromJson(response.data, MInOutConfirm.fromJson);

        if (responseApi.records != null && responseApi.records!.isNotEmpty) {
          final mInOutConfirmList = responseApi.records!;
          return mInOutConfirmList;
        } else {
          return [];
        }
      } else {
        throw Exception(
            'Error al obtener la lista de $title: ${response.statusCode}');
      }
    } on DioException catch (e) {
      final authDataNotifier = ref.read(authProvider.notifier);
      throw CustomErrorDioException(e, authDataNotifier);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<MInOut> getMInOutAndLine(
    String mInOut,
    bool isSOTrx,
    WidgetRef ref,
  ) async {
    await _dioInitialized;
    final String title = isSOTrx ? 'Shipment' : 'Material Receipt';
    try {
      final String url =
          "/api/v1/models/m_inout?\$expand=m_inoutline&\$filter=DocumentNo%20eq%20'${mInOut.toString()}'%20AND%20IsSOTrx%20eq%20$isSOTrx";
      final response = await dio.get(url);

      if (response.statusCode == 200) {
        final responseApi = ResponseApi<MInOut>.fromJson(response.data, MInOut.fromJson);

        if (responseApi.records != null && responseApi.records!.isNotEmpty) {
          final mInOut = responseApi.records!.first;
          return mInOut;
        } else {
          throw Exception('No se encontraron registros del $title');
        }
      } else {
        throw Exception(
            'Error al cargar los datos del $title: ${response.statusCode}');
      }
    } on DioException catch (e) {
      final authDataNotifier = ref.read(authProvider.notifier);
      throw CustomErrorDioException(e, authDataNotifier);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<MInOut> setDocAction(
    MInOut mInOut,
    bool isSOTrx,
    WidgetRef ref,
  ) async {
    await _dioInitialized;
    final String title = isSOTrx ? 'Shipment' : 'Material Receipt';
    String status = 'DR';
    if (mInOut.docStatus.id.toString() == 'DR') {
      status = 'IP';
    } else if (mInOut.docStatus.id.toString() == 'IP') {
      status = 'CO';
    }
    try {
      final String url =
          "/ADInterface/services/rest/model_adservice/set_docaction";

      final authData = ref.read(authProvider);
      final request = {
        'ModelSetDocActionRequest': ModelSetDocActionRequest(
          modelSetDocAction: ModelSetDocAction(
            serviceType: 'SetDocumentActionShipment',
            tableName: 'M_InOut',
            recordId: mInOut.id,
            docAction: status,
          ),
          adLoginRequest: AdLoginRequest(
            user: authData.userName,
            pass: authData.password,
            lang: "es_PY",
            clientId: authData.selectedClient!.id,
            roleId: authData.selectedRole!.id,
            orgId: authData.selectedOrganization!.id,
            warehouseId: authData.selectedWarehouse!.id,
            stage: 9,
          ),
        ).toJson()
      };

      final response = await dio.post(url, data: request);

      if (response.statusCode == 200) {
        final standardResponse =
            StandardResponse.fromJson(response.data['StandardResponse']);
        if (standardResponse.isError == false) {
          final mInOutResponse = await getMInOutAndLine(
              mInOut.documentNo!.toString(), isSOTrx, ref);
          if (mInOutResponse.id == mInOut.id) {
            return mInOut;
          } else {
            throw Exception('Error al confirmar el $title');
          }
        } else {
          throw Exception(standardResponse.error ?? 'Unknown error');
        }
      } else {
        throw Exception(
            'Error al cargar los datos del $title: ${response.statusCode}');
      }
    } on DioException catch (e) {
      final authDataNotifier = ref.read(authProvider.notifier);
      throw CustomErrorDioException(e, authDataNotifier);
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
