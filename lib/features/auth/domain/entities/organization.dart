class Organization {
  final int id;
  final String name;

  Organization({required this.id, required this.name});

  factory Organization.fromJson(Map<String, dynamic> json) {
    return Organization(
      id: json['id'] as int,
      name: json['name'] as String,
    );
  }

  @override
  String toString() {
    return 'Organization{id: $id, name: $name}';
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}
