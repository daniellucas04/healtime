class User {
  final int? id;
  final String name;
  final DateTime nascimento;

  User({this.id, required this.name, required this.nascimento});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'nascimento': nascimento.toIso8601String(),
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      name: map['name'],
      nascimento: DateTime.parse(map['nascimento']),
    );
  }
}
