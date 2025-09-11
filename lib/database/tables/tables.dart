class Tables {
  static String medications() {
    return '''
        CREATE TABLE medications (
          "id"	INTEGER NOT NULL,
          "name"	TEXT NOT NULL,
          "type"	TEXT NOT NULL,
          "frequency_type"	TEXT NOT NULL,
          "frequency_value" NUMERIC NOT NULL,
          "duration"	NUMERIC NOT NULL,
          "quantity"	NUMERIC NOT NULL,
          "first_medication"	TEXT NOT NULL,
          PRIMARY KEY("id" AUTOINCREMENT)
        )
      ''';
  }

  static String users() {
    return '''
    CREATE TABLE users (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      name TEXT NOT NULL,
      nascimento INTEGER
    )
  ''';
  }

  static String userMedication() {
    return '''
  CREATE TABLE usuario_medicamento (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    usuario_id INTEGER NOT NULL,
    medicamento_id INTEGER NOT NULL,
    FOREIGN KEY (usuario_id) REFERENCES users(id),
    FOREIGN KEY (medicamento_id) REFERENCES medicamentos(id)
  )
''';
  }
}
