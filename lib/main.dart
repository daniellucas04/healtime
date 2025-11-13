import 'dart:async';
import 'package:app/providers/theme_provider.dart';
import 'package:app/services/notifications.dart';
import 'package:app/views/homepage_screen.dart';
import 'package:app/views/router/router.dart';
import 'package:flutter/material.dart';
import 'package:app/views/theme/theme.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/data/latest.dart' as tz;

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
  late Future<bool> _firstTimeFuture;

  @override
  void initState() {
    super.initState();
    _configureNotificationListener();
    _firstTimeFuture = _checkFirstTime();
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

  Future<bool> _checkFirstTime() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isFirstTime = prefs.getBool('isFirstTime') ?? true;
    if (isFirstTime) {
      prefs.setBool('isFirstTime', false);
    }
    return isFirstTime;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return FutureBuilder<bool>(
          future: _firstTimeFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            bool isFirstTime = snapshot.data ?? false;

            Widget _buildPageRouteTransition(
              BuildContext context,
              Animation<double> animation,
              Animation<double> secondaryAnimation,
              Widget child,
              String? routeName,
            ) {
              const curve = Curves.easeInOut;

              if (routeName == '/tutorial_screen' || routeName == '/homepage') {
                return FadeTransition(
                  opacity: animation,
                  child: child,
                );
              } else {
                Offset begin;
                if (routeName == '/medicine_registration' ||
                    routeName == '/create_people') {
                  begin = const Offset(0.0, 1.0);
                } else if (routeName == '/people' || routeName == '/menu') {
                  begin = const Offset(1.0, 0.0);
                } else {
                  begin = const Offset(0.0, 0.0);
                }

                const end = Offset.zero;

                var tween = Tween(begin: begin, end: end)
                    .chain(CurveTween(curve: curve));
                var offsetAnimation = animation.drive(tween);

                return SlideTransition(
                  position: offsetAnimation,
                  child: child,
                );
              }
            }

            Widget app = MaterialApp(
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
              initialRoute: isFirstTime ? '/tutorial_screen' : '/homepage',
              onGenerateRoute: (settings) {
                final WidgetBuilder builder = routes[settings.name] ??
                    (context) => const HomePageScreen();

                return PageRouteBuilder(
                  pageBuilder: (context, animation, secondaryAnimation) {
                    final page = builder(context);
                    return page;
                  },
                  transitionDuration: const Duration(milliseconds: 400),
                  transitionsBuilder:
                      (context, animation, secondaryAnimation, child) {
                    return _buildPageRouteTransition(
                      context,
                      animation,
                      secondaryAnimation,
                      child,
                      settings.name,
                    );
                  },
                );
              },
            );

            return app;
          },
        );
      },
    );
  }
}
