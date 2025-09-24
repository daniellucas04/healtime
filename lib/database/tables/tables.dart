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

  static String medicationSchedule() {
    return '''
          CREATE TABLE medication_schedule (
            "id" INTEGER NOT NULL,
            "date" TEXT NOT NULL,
            "status" TEXT NOT NULL,
            "medication_id" INTEGER NOT NULL,
            PRIMARY KEY ("id" AUTOINCREMENT)
          )
    ''';
  }

  static String users() {
    return '''
        CREATE TABLE users (
          "id" INTEGER NOT NULL,
          "name" TEXT NOT NULL,
          "nascimento" INTEGER NOT NULL,
          "status" TEXT NOT NULL,
          PRIMARY KEY("id" AUTOINCREMENT)
        )
      ''';
  }

  static String usersMedication() {
    return '''
        CREATE TABLE user_medication (
          "id" INTEGER NOT NULL,
          "user_id" INTEGER NOT NULL,
          "medication_id" INTEGER NOT NULL,
          PRIMARY KEY ("id" AUTOINCREMENT),
          FOREIGN KEY (user_id) REFERENCES users(id),
          FOREIGN KEY (medication_id) REFERENCES medications(id)
        )
  ''';
  }
}
