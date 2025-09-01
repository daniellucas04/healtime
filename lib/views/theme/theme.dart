import 'package:flutter/material.dart';

const Color textLightTheme = Color.fromARGB(255, 1, 24, 21);
const Color textLightTheme900 = Color.fromARGB(255, 2, 49, 43);
const Color backgroundLightTheme = Color.fromARGB(255, 241, 254, 252);
const Color backgroundLightTheme100 = Color.fromARGB(255, 207, 252, 245);
const Color backgroundLightTheme50 = Color.fromARGB(255, 231, 253, 250);
const Color primaryLightTheme = Color.fromARGB(255, 32, 243, 222);
const Color secondaryLightTheme = Color.fromARGB(255, 110, 178, 247);
const Color secondaryLightTheme400 = Color.fromARGB(255, 61, 153, 245);
const Color accentLightTheme = Color.fromARGB(255, 77, 127, 245);

const Color textDarkTheme = Color.fromARGB(255, 231, 254, 251);
const Color backgroundDarkTheme = Color.fromARGB(255, 1, 14, 12);
const Color backgroundDarkTheme50 = Color.fromARGB(255, 2, 24, 21);
const Color primaryDarkTheme = Color.fromARGB(255, 12, 223, 202);
const Color secondaryDarkTheme = Color.fromARGB(255, 8, 76, 255);
const Color secondaryDarkTheme500 = Color.fromARGB(255, 0, 72, 255);
const Color accentDarkTheme = Color.fromARGB(255, 10, 61, 178);

class AppThemes {
  static final ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    scaffoldBackgroundColor: backgroundLightTheme,
    appBarTheme: const AppBarTheme(
      backgroundColor: accentLightTheme,
      foregroundColor: textLightTheme,
      elevation: 0,
    ),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: textLightTheme),
      bodyMedium: TextStyle(color: textLightTheme),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: secondaryLightTheme,
      foregroundColor: textDarkTheme,
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: backgroundLightTheme50,
      selectedIconTheme: IconThemeData(size: 32, color: secondaryLightTheme),
      selectedItemColor: secondaryLightTheme,
      unselectedIconTheme: IconThemeData(size: 32, color: textLightTheme900),
      unselectedItemColor: textLightTheme900,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        foregroundColor: WidgetStateProperty.resolveWith<Color?>(
          (Set<WidgetState> states) {
            return textLightTheme; // Default color
          },
        ),
        backgroundColor: WidgetStateProperty.resolveWith<Color?>(
          (Set<WidgetState> states) {
            if (states.contains(WidgetState.pressed)) {
              return secondaryLightTheme400;
            } else {
              return accentLightTheme;
            }
          },
        ),
        textStyle: WidgetStateProperty.all(
          const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
    ),
    inputDecorationTheme: InputDecorationThemeData(
      floatingLabelAlignment: FloatingLabelAlignment.start,
      floatingLabelStyle: const TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 20,
        color: textLightTheme,
      ),
      labelStyle: const TextStyle(
        color: textLightTheme,
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.black87, width: 2.0),
        borderRadius: BorderRadius.circular(100),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.black12, width: 2.0),
        borderRadius: BorderRadius.circular(100),
      ),
    ),
    dropdownMenuTheme: const DropdownMenuThemeData(
      textStyle: TextStyle(
        color: textLightTheme
      ),
      menuStyle: MenuStyle(
        backgroundColor: WidgetStatePropertyAll(backgroundLightTheme50),
      ),
    ),
    cardTheme: const CardThemeData(
    color: accentLightTheme,
    shadowColor: Colors.black38,
    ),
    listTileTheme: const ListTileThemeData(
      iconColor: primaryLightTheme,
      textColor: textLightTheme,
    ),
    dialogTheme: const DialogThemeData(
      backgroundColor: backgroundLightTheme50,
      shadowColor: Colors.black38,
      iconColor: textLightTheme,
      titleTextStyle: TextStyle(
        color: textLightTheme,
        fontSize: 24,
      ),
      contentTextStyle: TextStyle(color: textLightTheme),
    ),
    textButtonTheme: const TextButtonThemeData(
      style: ButtonStyle(
        alignment: Alignment.centerLeft,
        foregroundColor: WidgetStatePropertyAll(textLightTheme),
      ),
    ),
  );

  static final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: backgroundDarkTheme,
    appBarTheme: const AppBarTheme(
      backgroundColor: secondaryDarkTheme,
      foregroundColor: textDarkTheme,
      elevation: 0,
    ),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: textDarkTheme),
      bodyMedium: TextStyle(color: textDarkTheme),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: backgroundDarkTheme50,
      selectedIconTheme: IconThemeData(size: 32, color: secondaryDarkTheme),
      selectedItemColor: secondaryDarkTheme,
      unselectedIconTheme: IconThemeData(size: 32, color: textDarkTheme),
      unselectedItemColor: textDarkTheme,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        foregroundColor: WidgetStateProperty.resolveWith<Color?>(
          (Set<WidgetState> states) {
            return textDarkTheme; // Default color
          },
        ),
        backgroundColor: WidgetStateProperty.resolveWith<Color?>(
          (Set<WidgetState> states) {
            if (states.contains(WidgetState.pressed)) {
              return secondaryDarkTheme;
            } else {
              return secondaryDarkTheme500;
            }
          },
        ),
        textStyle: WidgetStateProperty.all(
          const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: secondaryDarkTheme,
      foregroundColor: backgroundDarkTheme,
    ),
    inputDecorationTheme: InputDecorationThemeData(
      floatingLabelAlignment: FloatingLabelAlignment.start,
      floatingLabelStyle: const TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 20,
        color: textDarkTheme,
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.white, width: 2.0),
        borderRadius: BorderRadius.circular(100),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.white60, width: 2.0),
        borderRadius: BorderRadius.circular(100),
      ),
    ),
    dropdownMenuTheme: const DropdownMenuThemeData(
      textStyle: TextStyle(
        color: textDarkTheme
      ),
      menuStyle: MenuStyle(
        backgroundColor: WidgetStatePropertyAll(backgroundDarkTheme50),
      ),
    ),
    cardTheme: const CardThemeData(
      color: accentDarkTheme,
      shadowColor: Colors.white30,
    ),
    dialogTheme: const DialogThemeData(
      backgroundColor: backgroundDarkTheme50,
      shadowColor: Colors.white30,
      iconColor: textDarkTheme,
      titleTextStyle: TextStyle(
        color: textDarkTheme,
        fontSize: 24,
      ),
      contentTextStyle: TextStyle(color: textDarkTheme),
    ),
    listTileTheme: const ListTileThemeData(
      iconColor: primaryDarkTheme,
      textColor: textDarkTheme,
    ),
    textButtonTheme: const TextButtonThemeData(
      style: ButtonStyle(
        alignment: Alignment.centerLeft,
        foregroundColor: WidgetStatePropertyAll(textDarkTheme),
      ),
    ),
  );
}
