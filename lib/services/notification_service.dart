import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/foundation.dart';
import 'dart:ui';

class NotificationService {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin = FlutterLocalNotificationsPlugin();

  static Future<void> init() async {
    if (kIsWeb) return;

    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings initializationSettingsIOS = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    await _notificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        // Handle notification tap logic here
      },
    );
  }

  static Future<void> showNotification({
    required int id,
    required String title,
    required String body,
    String? payload,
  }) async {
    if (kIsWeb) return;

    final BigTextStyleInformation bigTextStyleInformation = BigTextStyleInformation(
      body,
      htmlFormatBigText: true,
      contentTitle: '<b>$title</b>',
      htmlFormatContentTitle: true,
      summaryText: '<i>SurveySync Update</i>',
      htmlFormatSummaryText: true,
    );

    final AndroidNotificationDetails androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'survey_sync_channel',
      'SurveySync Notifications',
      channelDescription: 'Notifications for survey submissions and reminders',
      importance: Importance.max,
      priority: Priority.high,
      showWhen: true,
      color: const Color(0xFF3F51B5), // Indigo brand color
      styleInformation: bigTextStyleInformation,
      enableLights: true,
      ledColor: const Color(0xFF009688), // Teal LED color
      ledOnMs: 1000,
      ledOffMs: 500,
    );

    final NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: const DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      ),
    );

    await _notificationsPlugin.show(
      id,
      title,
      body,
      platformChannelSpecifics,
      payload: payload,
    );
  }
}
