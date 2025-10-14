import 'dart:async';

import 'package:app/providers/theme_provider.dart';
import 'package:app/services/notifications.dart';
import 'package:app/views/homepage_screen.dart';
import 'package:app/views/router/router.dart';
import 'package:flutter/material.dart';
import 'package:app/views/theme/theme.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  tz.initializeTimeZones();

  final notificationService = NotificationService();
  await notificationService.initialize();
  await notificationService.requestPermissions();

  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final NotificationService _notificationService = NotificationService();
  StreamSubscription? _notificationSubscription;

  @override
  void initState() {
    super.initState();
    _configureNotificationListener();
  }

  void _configureNotificationListener() {
    _notificationSubscription = _notificationService.notificationStream.listen(
      (response) {
        Navigator.of(context).push(
          MaterialPageRoute<void>(
            builder: (BuildContext context) => const HomePageScreen(),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _notificationSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return MaterialApp(
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('pt'),
          ],
          debugShowCheckedModeBanner: false,
          theme: AppThemes.lightTheme,
          darkTheme: AppThemes.darkTheme,
          themeMode: themeProvider.themeMode,
          initialRoute: '/',
          routes: routes,
        );
      },
    );
  }
}
