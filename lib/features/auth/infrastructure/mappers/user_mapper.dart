import '../../domain/domain.dart';

class UserMapper {
  static User userJsonToEntity(Map<String, dynamic> json) => User(
        id: json['id'],
        userName: json['userName'],
        fullName: json['fullName'],
        roles: List<String>.from(json['roles'].map((role) => role)),
        token: json['token'] ?? '',
      );
}
