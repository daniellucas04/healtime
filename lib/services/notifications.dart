import 'dart:async';
import 'dart:io';

import 'package:app/models/medicationschedule.dart';
import 'package:app/views/medicine/create_medication_step9_notifications.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();

  final StreamController<NotificationResponse> _notificationResponseController =
      StreamController<NotificationResponse>.broadcast();

  Stream<NotificationResponse> get notificationStream =>
      _notificationResponseController.stream;

  bool _isInitialized = false;
  bool _notificationsEnabled = false;

  bool get isInitialized => _isInitialized;
  bool get notificationsEnabled => _notificationsEnabled;

  FlutterLocalNotificationsPlugin get plugin => _notifications;

  // Constantes
  static const String darwinNotificationCategoryText = 'textCategory';
  static const String darwinNotificationCategoryPlain = 'plainCategory';
  static const String urlLaunchActionId = 'id_1';
  static const String navigationActionId = 'id_3';

  /// Inicializa o serviço de notificações
  Future<void> initialize() async {
    if (_isInitialized) return;

    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('notification_icon');

    const AndroidNotificationChannel medicationChannel =
        AndroidNotificationChannel(
      'med_channel',
      'Medicamentos',
      description: 'Notificações de medicamentos agendados',
      importance: Importance.high,
      playSound: true,
      enableVibration: true,
    );

    await FlutterLocalNotificationsPlugin()
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(medicationChannel);

    final List<DarwinNotificationCategory> darwinNotificationCategories =
        <DarwinNotificationCategory>[
      DarwinNotificationCategory(
        darwinNotificationCategoryText,
        actions: <DarwinNotificationAction>[
          DarwinNotificationAction.text(
            'text_1',
            'Action 1',
            buttonTitle: 'Send',
            placeholder: 'Placeholder',
          ),
        ],
      ),
      DarwinNotificationCategory(
        darwinNotificationCategoryPlain,
        actions: <DarwinNotificationAction>[
          DarwinNotificationAction.plain('id_1', 'Action 1'),
          DarwinNotificationAction.plain(
            'id_2',
            'Action 2 (destructive)',
            options: <DarwinNotificationActionOption>{
              DarwinNotificationActionOption.destructive,
            },
          ),
          DarwinNotificationAction.plain(
            navigationActionId,
            'Action 3 (foreground)',
            options: <DarwinNotificationActionOption>{
              DarwinNotificationActionOption.foreground,
            },
          ),
          DarwinNotificationAction.plain(
            'id_4',
            'Action 4 (auth required)',
            options: <DarwinNotificationActionOption>{
              DarwinNotificationActionOption.authenticationRequired,
            },
          ),
        ],
        options: <DarwinNotificationCategoryOption>{
          DarwinNotificationCategoryOption.hiddenPreviewShowTitle,
        },
      )
    ];

    final DarwinInitializationSettings initializationSettingsDarwin =
        DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
      notificationCategories: darwinNotificationCategories,
    );

    final InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsDarwin,
      macOS: initializationSettingsDarwin,
    );

    await _notifications.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: _onNotificationResponse,
    );

    await _checkPermissions();
    _isInitialized = true;
  }

  void _onNotificationResponse(NotificationResponse response) {
    print('Notificação recebida com ID: ${response.id}');
    _notificationResponseController.add(response);
  }

  /// Verifica permissões de notificação
  Future<void> _checkPermissions() async {
    if (Platform.isAndroid) {
      final bool granted = await _notifications
              .resolvePlatformSpecificImplementation<
                  AndroidFlutterLocalNotificationsPlugin>()
              ?.areNotificationsEnabled() ??
          false;
      _notificationsEnabled = granted;
    }
  }

  Future<void> _openAppSettingsWithPrompt() async {
    final status = await Permission.notification.status;

    if (status.isPermanentlyDenied || status.isDenied) {
      await openAppSettings();
    }
  }

  Future<bool> hasPermission() async {
    if (Platform.isAndroid) {
      final androidPlugin =
          _notifications.resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>();

      return await androidPlugin?.areNotificationsEnabled() ?? false;
    }

    if (Platform.isIOS || Platform.isMacOS) {
      return _notificationsEnabled;
    }

    return false;
  }

  /// Solicita permissões de notificação
  Future<bool> requestPermissions() async {
    if (Platform.isIOS || Platform.isMacOS) {
      final bool? result = await _notifications
          .resolvePlatformSpecificImplementation<
              IOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(
            alert: true,
            badge: true,
            sound: true,
          );

      _notificationsEnabled = result ?? false;

      if (!_notificationsEnabled) {
        await _openAppSettingsWithPrompt();
      }

      return _notificationsEnabled;
    } else if (Platform.isAndroid) {
      final AndroidFlutterLocalNotificationsPlugin? androidImplementation =
          _notifications.resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>();

      final bool? grantedNotificationPermission =
          await androidImplementation?.requestNotificationsPermission();

      _notificationsEnabled = grantedNotificationPermission ?? false;

      if (!_notificationsEnabled) {
        await _openAppSettingsWithPrompt();
      }

      return _notificationsEnabled;
    }

    return false;
  }

  /// Mostra uma notificação simples
  Future<void> showNotification({
    required int id,
    required String title,
    required String body,
    String? payload,
  }) async {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
      'med_channel',
      'Medicamentos',
      channelDescription: 'Notificações de medicamentos agendados',
      importance: Importance.max,
      priority: Priority.high,
    );

    const DarwinNotificationDetails iosDetails = DarwinNotificationDetails();

    const NotificationDetails platformDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _notifications.show(
      id,
      title,
      body,
      platformDetails,
      payload: payload,
    );
  }

  Future<void> scheduleMedicationNotifications(
      MedicationSchedule medicationSchedule, NotificationsType type) async {
    final DateTime scheduledDate = DateTime.parse(medicationSchedule.date);
    final int notificationId = medicationSchedule.id ?? UniqueKey().hashCode;

    late DateTime notificationTime;
    late final String body;
    print(medicationSchedule.medication?.name);
    String? medicationName = medicationSchedule.medication?.name.toUpperCase();

    switch (type) {
      case NotificationsType.inHour:
        notificationTime = scheduledDate;
        body = 'Hora de tomar o medicamento: $medicationName!';
        break;

      case NotificationsType.advance:
        notificationTime = scheduledDate.subtract(const Duration(minutes: 15));
        body =
            'Você tem um medicamento $medicationName às ${scheduledDate.hour.toString().padLeft(2, '0')}:${scheduledDate.minute.toString().padLeft(2, '0')}';
        break;

      case NotificationsType.delayed:
        notificationTime = scheduledDate.add(const Duration(minutes: 10));
        body = 'Você esqueceu de tomar o medicamento: $medicationName?';
        break;

      default:
    }

    tz.TZDateTime scheduledTime = tz.TZDateTime.from(
        notificationTime, tz.getLocation('America/Sao_Paulo'));

    print(scheduledTime);
    _checkPendingNotificationRequests();
    if (notificationTime.isAfter(DateTime.now())) {
      await _notifications.zonedSchedule(
        notificationId + type.index,
        'Lembrete de Medicamento',
        body,
        scheduledTime,
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'med_channel',
            'Medicamentos',
            channelDescription: 'Notificações de medicamentos agendados',
          ),
        ),
        androidScheduleMode: AndroidScheduleMode.alarmClock,
      );
    }
  }

  /// Cancela uma notificação específica
  Future<void> cancelNotification(int id) async {
    await _notifications.cancel(id);
  }

  /// Cancela todas as notificações
  Future<void> cancelAllNotifications() async {
    await _notifications.cancelAll();
  }

  /// Obtém detalhes de lançamento da app
  Future<NotificationAppLaunchDetails?>
      getNotificationAppLaunchDetails() async {
    if (!kIsWeb && !Platform.isLinux) {
      return await _notifications.getNotificationAppLaunchDetails();
    }
    return null;
  }

  Future<void> _checkPendingNotificationRequests() async {
    final List<PendingNotificationRequest> pendingNotificationRequests =
        await _notifications.pendingNotificationRequests();
    print('${pendingNotificationRequests.length} pending notification ');

    for (PendingNotificationRequest pendingNotificationRequest
        in pendingNotificationRequests) {
      print(pendingNotificationRequest.id.toString() +
          " " +
          (pendingNotificationRequest.payload ?? ""));
    }
    print('NOW ' + tz.TZDateTime.now(tz.local).toString());
  }

  /// Dispose do serviço
  void dispose() {
    _notificationResponseController.close();
  }
}
