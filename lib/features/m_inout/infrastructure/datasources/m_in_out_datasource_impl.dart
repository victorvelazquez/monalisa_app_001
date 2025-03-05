import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:monalisa_app_001/features/m_inout/domain/entities/line_confirm.dart';
import 'package:monalisa_app_001/features/shared/domain/entities/model_crud.dart';
import 'package:monalisa_app_001/features/shared/domain/entities/model_crud_request.dart';
import 'package:monalisa_app_001/features/shared/domain/entities/response_api.dart';
import 'package:monalisa_app_001/features/m_inout/domain/datasources/m_inout_datasource.dart';
import 'package:monalisa_app_001/features/m_inout/domain/entities/m_in_out.dart';
import 'package:monalisa_app_001/features/shared/domain/entities/standard_response.dart';

import '../../../../config/config.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../shared/domain/entities/ad_login_request.dart';
import '../../../shared/domain/entities/field_crud.dart';
import '../../../shared/domain/entities/model_set_doc_action.dart';
import '../../../shared/domain/entities/model_set_doc_action_request.dart';
import '../../../shared/shared.dart';
import '../../domain/entities/line.dart';
import '../../domain/entities/m_in_out_confirm.dart';
import '../../presentation/providers/m_in_out_providers.dart';

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
  Future<List<MInOut>> getMInOutList(WidgetRef ref) async {
    await _dioInitialized;
    final mInOutState = ref.watch(mInOutProvider);
    final int warehouseID = ref.read(authProvider).selectedWarehouse!.id;

    try {
      final String url =
          "/api/v1/models/m_inout?\$filter=IsSOTrx%20eq%20${mInOutState.isSOTrx}%20AND%20M_Warehouse_ID%20eq%20$warehouseID%20AND%20(DocStatus%20eq%20'DR'%20OR%20DocStatus%20eq%20'IP')";

      final response = await dio.get(url);

      if (response.statusCode == 200) {
        final responseApi =
            ResponseApi<MInOut>.fromJson(response.data, MInOut.fromJson);

        if (responseApi.records != null && responseApi.records!.isNotEmpty) {
          final mInOutList = responseApi.records!;
          return mInOutList;
        } else {
          return [];
        }
      } else {
        throw Exception(
            'Error al obtener la lista de ${mInOutState.title}: ${response.statusCode}');
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
      int mInOutId, WidgetRef ref) async {
    await _dioInitialized;
    final mInOutState = ref.watch(mInOutProvider);

    final String confirmType =
        mInOutState.mInOutType == MInOutType.receiptConfirm ||
                mInOutState.mInOutType == MInOutType.shipmentConfirm
            ? "%20AND%20ConfirmType%20eq%20'SC'"
            : mInOutState.mInOutType == MInOutType.pickConfirm ||
                    mInOutState.mInOutType == MInOutType.qaConfirm
                ? "%20AND%20ConfirmType%20eq%20'PC'"
                : "";

    try {
      final String url =
          "/api/v1/models/m_inoutConfirm?\$filter=M_InOut_ID%20eq%20$mInOutId$confirmType";

      final response = await dio.get(url);

      if (response.statusCode == 200) {
        final responseApi = ResponseApi<MInOutConfirm>.fromJson(
            response.data, MInOutConfirm.fromJson);

        if (responseApi.records != null && responseApi.records!.isNotEmpty) {
          final mInOutConfirmList = responseApi.records!;
          return mInOutConfirmList;
        } else {
          return [];
        }
      } else {
        throw Exception(
            'Error al obtener la lista de ${mInOutState.title}: ${response.statusCode}');
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
    String mInOutDoc,
    WidgetRef ref,
  ) async {
    await _dioInitialized;
    final mInOutState = ref.watch(mInOutProvider);
    final int warehouseID = ref.read(authProvider).selectedWarehouse!.id;
    try {
      final String url =
          "/api/v1/models/m_inout?\$expand=m_inoutline&\$filter=DocumentNo%20eq%20'${mInOutDoc.toString()}'%20AND%20IsSOTrx%20eq%20${mInOutState.isSOTrx}%20AND%20M_Warehouse_ID%20eq%20$warehouseID";
      final response = await dio.get(url);

      if (response.statusCode == 200) {
        final responseApi =
            ResponseApi<MInOut>.fromJson(response.data, MInOut.fromJson);

        if (responseApi.records != null && responseApi.records!.isNotEmpty) {
          final mInOut = responseApi.records!.first;
          return mInOut;
        } else {
          throw Exception(
              'No se encontraron registros del ${mInOutState.title}');
        }
      } else {
        throw Exception(
            'Error al cargar los datos del ${mInOutState.title}: ${response.statusCode}');
      }
    } on DioException catch (e) {
      final authDataNotifier = ref.read(authProvider.notifier);
      throw CustomErrorDioException(e, authDataNotifier);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<MInOutConfirm> getMInOutConfirmAndLine(
    int mInOutConfirmId,
    WidgetRef ref,
  ) async {
    await _dioInitialized;
    final mInOutState = ref.watch(mInOutProvider);
    try {
      final String url =
          "/api/v1/models/m_inoutconfirm?\$expand=m_inoutlineconfirm&\$filter=M_InOutConfirm_ID%20eq%20$mInOutConfirmId";
      final response = await dio.get(url);

      if (response.statusCode == 200) {
        final responseApi = ResponseApi<MInOutConfirm>.fromJson(
            response.data, MInOutConfirm.fromJson);

        if (responseApi.records != null && responseApi.records!.isNotEmpty) {
          final mInOutConfirm = responseApi.records!.first;
          return mInOutConfirm;
        } else {
          throw Exception(
              'No se encontraron registros del ${mInOutState.title}');
        }
      } else {
        throw Exception(
            'Error al cargar los datos del ${mInOutState.title}: ${response.statusCode}');
      }
    } on DioException catch (e) {
      final authDataNotifier = ref.read(authProvider.notifier);
      throw CustomErrorDioException(e, authDataNotifier);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<MInOut> setDocAction(WidgetRef ref) async {
    await _dioInitialized;
    final mInOutState = ref.watch(mInOutProvider);
    final isConfirm = mInOutState.mInOutConfirm?.docStatus.id != null;
    final currentStatus = mInOutState.mInOutConfirm?.docStatus.id?.toString() ??
        mInOutState.mInOut?.docStatus.id?.toString() ??
        'DR';
    final status = isConfirm
        ? 'CO'
        : currentStatus == 'DR'
            ? 'PR'
            : currentStatus == 'IP'
                ? 'CO'
                : 'DR';

    try {
      final String url =
          "/ADInterface/services/rest/model_adservice/set_docaction";
      final authData = ref.read(authProvider);
      final request = {
        'ModelSetDocActionRequest': ModelSetDocActionRequest(
          modelSetDocAction: ModelSetDocAction(
            serviceType: 'SetDocumentActionShipment',
            tableName: isConfirm ? 'M_InOutConfirm' : 'M_InOut',
            recordId: isConfirm
                ? mInOutState.mInOutConfirm!.id
                : mInOutState.mInOut!.id,
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
          if (isConfirm) {
            return mInOutState.mInOut!;
          } else {
            final mInOutResponse = await getMInOutAndLine(
                mInOutState.mInOut!.documentNo!.toString(), ref);
            if (mInOutResponse.id == mInOutState.mInOut!.id) {
              return mInOutResponse;
            } else {
              throw Exception('Error al confirmar el ${mInOutState.title}');
            }
          }
        } else {
          throw Exception(standardResponse.error ?? 'Unknown error');
        }
      } else {
        throw Exception(
            'Error al cargar los datos del ${mInOutState.title}: ${response.statusCode}');
      }
    } on DioException catch (e) {
      final authDataNotifier = ref.read(authProvider.notifier);
      throw CustomErrorDioException(e, authDataNotifier);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<LineConfirm> updateLineConfirm(Line line, WidgetRef ref) async {
    await _dioInitialized;
    try {
      final String url =
          "/ADInterface/services/rest/model_adservice/update_data";

      final authData = ref.read(authProvider);
      final request = {
        'ModelCRUDRequest': ModelCrudRequest(
          modelCrud: ModelCrud(
            serviceType: 'UpdateInOutLineConfirm',
            tableName: 'M_InOutLineConfirm',
            recordId: line.confirmId,
            action: "Update",
            dataRow: {
              'field': [
                FieldCrud(
                    column: 'ConfirmedQty', val: line.confirmedQty.toString()),
                FieldCrud(
                    column: 'DifferenceQty',
                    val: line.differenceQty.toString()),
                FieldCrud(
                    column: 'ScrappedQty', val: line.scrappedQty.toString()),
              ].map((field) => field.toJson()).toList(),
            },
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
        if (standardResponse.isError == null ||
            standardResponse.isError == false) {
          LineConfirm lineResponse = LineConfirm(
            id: line.confirmId,
          );
          return lineResponse;
        } else {
          throw Exception(standardResponse.error ?? 'Unknown error');
        }
      } else {
        throw Exception(
            'Error al cargar los datos de la línea ${line.line}: ${response.statusCode}');
      }
    } on DioException catch (e) {
      final authDataNotifier = ref.read(authProvider.notifier);
      throw CustomErrorDioException(e, authDataNotifier);
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
