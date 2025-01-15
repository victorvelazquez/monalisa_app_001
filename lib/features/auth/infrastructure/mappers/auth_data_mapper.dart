import '../../domain/dtos/auth_data.dart';

class AuthDataMapper {
  static AuthDataDto authDataDtoJsonToEntity(Map<String, dynamic> json) =>
      AuthDataDto(
        client: json['client'],
        role: json['role'],
        organization: json['organization'],
        warehouse: json['warehouse'],
        userId: json['userId'],
        language: json['language'],
        token: json['token'],
        refreshToken: json['refresh_token'],
      );
}
