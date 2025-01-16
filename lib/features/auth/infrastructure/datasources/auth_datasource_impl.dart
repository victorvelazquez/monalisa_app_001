import 'package:dio/dio.dart';
import 'package:monalisa_app_001/config/config.dart';
import 'package:monalisa_app_001/features/auth/domain/domain.dart';
import 'package:monalisa_app_001/features/auth/domain/dtos/auth_data.dart';
import 'package:monalisa_app_001/features/auth/domain/dtos/login_dto.dart';
import 'package:monalisa_app_001/features/auth/domain/dtos/organization_dto.dart';
import 'package:monalisa_app_001/features/auth/domain/dtos/role_dto.dart';
import 'package:monalisa_app_001/features/auth/domain/dtos/warehouse_dto.dart';
import 'package:monalisa_app_001/features/auth/infrastructure/mappers/auth_data_mapper.dart';
import 'package:monalisa_app_001/features/auth/infrastructure/mappers/login_mapper.dart';
import 'package:monalisa_app_001/features/auth/infrastructure/mappers/organization_mapper.dart';
import 'package:monalisa_app_001/features/auth/infrastructure/mappers/role_mapper.dart';
import 'package:monalisa_app_001/features/shared/shared.dart';

import '../mappers/warehouse_mapper.dart';

class AuthDataSourceImpl implements AuthDataSource {
  late final Dio dio;

  AuthDataSourceImpl() {
    _initDio();
  }

  Future<void> _initDio() async {
    dio = await DioClient.create();
  }

  @override
  Future<LoginDto> login(String userName, String password) async {
    try {
      final response = await dio.post('/api/v1/auth/tokens',
          data: {'userName': userName, 'password': password});

      final loginResponse = LoginMapper.loginDtoJsonToEntity(response.data);

      return loginResponse;
    } on DioException catch (e) {
      print(e);
      throw CustomErrorDioException(e);
    } catch (e) {
      throw Exception('ERROR: ${e.toString()}');
    }
  }

  @override
  Future<String> checkAuthStatus(String token) async {
    try {
      // final response = await dio.get('/auth/check-status',
      //     options: Options(headers: {
      //       'Authorization': 'Bearer $token',
      //     }));

      final newToken = '';
      return newToken;
    } on DioException catch (e) {
      throw CustomErrorDioException(e);
    } catch (e) {
      throw Exception('ERROR: ${e.toString()}');
    }
  }

  @override
  Future<RoleDto> getRoles(int clientId, String token) async {
    try {
      final response = await dio.get('/api/v1/auth/roles?client=$clientId',
          options: Options(headers: {
            'Authorization': 'Bearer $token',
          }));

      final rolesResponse = RoleMapper.roleDtoJsonToEntity(response.data);
      return rolesResponse;
    } on DioException catch (e) {
      print(e);
      throw CustomErrorDioException(e);
    } catch (e) {
      throw Exception('ERROR: ${e.toString()}');
    }
  }

  @override
  Future<OrganizationDto> getOrganizations(
      int clientId, int roleId, String token) async {
    try {
      final response = await dio.get(
          '/api/v1/auth/organizations?client=$clientId&role=$roleId',
          options: Options(headers: {
            'Authorization': 'Bearer $token',
          }));

      final organizationsResponse =
          OrganizationMapper.organizationDtoJsonToEntity(response.data);
      return organizationsResponse;
    } on DioException catch (e) {
      print(e);
      throw CustomErrorDioException(e);
    } catch (e) {
      throw Exception('ERROR: ${e.toString()}');
    }
  }

  @override
  Future<WarehouseDto> getWarehouses(
      int clientId, int roleId, int organizationId, String token) async {
    try {
      final response = await dio.get(
          '/api/v1/auth/warehouses?client=$clientId&role=$roleId&organization=$organizationId',
          options: Options(headers: {
            'Authorization': 'Bearer $token',
          }));

      final warehousesResponse =
          WarehouseMapper.warehouseDtoJsonToEntity(response.data);
      return warehousesResponse;
    } on DioException catch (e) {
      print(e);
      throw CustomErrorDioException(e);
    } catch (e) {
      throw Exception('ERROR: ${e.toString()}');
    }
  }

  @override
  Future<AuthDataDto> getAuthData(int clientId, int roleId, int organizationId,
      int warehouseId, String token) async {
    try {
      final response = await dio.put(
        '/api/v1/auth/tokens',
        options: Options(headers: {
          'Authorization': 'Bearer $token',
        }),
        data: {
          "clientId": clientId,
          "roleId": roleId,
          "organizationId": organizationId,
          "warehouseId": warehouseId,
          "language": "es_PY",
        },
      );

      final authDataResponse =
          AuthDataMapper.authDataDtoJsonToEntity(response.data);
      return authDataResponse;
    } on DioException catch (e) {
      print(e);
      throw CustomErrorDioException(e);
    } catch (e) {
      throw Exception('ERROR: ${e.toString()}');
    }
  }
}
