class User {
  final String id;
  final String userName;
  final String fullName;
  final List<String> roles;
  final String token;

  User(
      {required this.id,
      required this.userName,
      required this.fullName,
      required this.roles,
      required this.token});

  bool get isAdmin {
    return roles.contains('admin');
  }
}
