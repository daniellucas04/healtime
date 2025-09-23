class User {
  final int? id;
  final String name;
  final DateTime birthDate;

  User({this.id, required this.name, required this.birthDate});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'birth_date': birthDate.toIso8601String(),
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      name: map['name'],
      birthDate: DateTime.parse(map['birth_date']),
    );
  }
}
