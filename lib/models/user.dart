class User {
  final int? id;
  final String name;
  final String birthDate;

  User({this.id, required this.name, required this.birthDate});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'birth_date': birthDate,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'] as int,
      name: map['name'] as String,
      birthDate: map['birth_date'] as String,
    );
  }
}
