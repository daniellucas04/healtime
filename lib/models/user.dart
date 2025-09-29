class User {
  final int? id;
  final String name;
  final String birthDate;
  final int active;

  User(
      {this.id,
      required this.name,
      required this.birthDate,
      required this.active});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'birth_date': birthDate,
      'active': active,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'] as int,
      name: map['name'] as String,
      birthDate: map['birth_date'] as String,
      active: map['active'] as int,
    );
  }
}
