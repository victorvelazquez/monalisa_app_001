import 'package:monalisa_app_001/features/auth/domain/dtos/auth_data_dto.dart';
import 'package:monalisa_app_001/features/auth/domain/dtos/login_dto.dart';

import '../dtos/organization_dto.dart';
import '../dtos/role_dto.dart';
import '../dtos/warehouse_dto.dart';

abstract class AuthRepository {
  Future<LoginDto> login(String userName, String password);
  Future<String> checkAuthStatus(String token);
  Future<RoleDto> getRoles(int clientId, String token);
  Future<OrganizationDto> getOrganizations(
      int clientId, int roleId, String token);
  Future<WarehouseDto> getWarehouses(
      int clientId, int roleId, int organizationId, String token);
  Future<AuthDataDto> getAuthData(int clientId, int roleId,
      int organizationId, int warehouseId, String token);
}
