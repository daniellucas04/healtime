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
}
