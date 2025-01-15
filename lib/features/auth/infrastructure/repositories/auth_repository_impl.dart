import 'package:monalisa_app_001/features/auth/domain/domain.dart';
import 'package:monalisa_app_001/features/auth/domain/dtos/auth_data.dart';
import 'package:monalisa_app_001/features/auth/domain/dtos/login_dto.dart';
import 'package:monalisa_app_001/features/auth/domain/dtos/organization_dto.dart';
import 'package:monalisa_app_001/features/auth/domain/dtos/role_dto.dart';
import 'package:monalisa_app_001/features/auth/domain/dtos/warehouse_dto.dart';
import '../infrastructure.dart';

class AuthRepositoryImpl extends AuthRepository {
  final AuthDataSource dataSource;

  AuthRepositoryImpl({AuthDataSource? dataSource})
      : dataSource = dataSource ?? AuthDataSourceImpl();

  @override
  Future<User> checkAuthStatus(String token) {
    return dataSource.checkAuthStatus(token);
  }

  @override
  Future<LoginDto> login(String userName, String password) {
    return dataSource.login(userName, password);
  }

  @override
  Future<RoleDto> getRoles(int clientId, String token) {
    return dataSource.getRoles(clientId, token);
  }

  @override
  Future<OrganizationDto> getOrganizations(
      int clientId, int roleId, String token) {
    return dataSource.getOrganizations(clientId, roleId, token);
  }

  @override
  Future<WarehouseDto> getWarehouses(
      int clientId, int roleId, int organizationId, String token) {
    return dataSource.getWarehouses(clientId, roleId, organizationId, token);
  }

  @override
  Future<AuthDataDto> getAuthData(int clientId, int roleId,
      int organizationId, int warehouseId, String token) {
    return dataSource.getAuthData(
        clientId, roleId, organizationId, warehouseId, token);
  }
}
