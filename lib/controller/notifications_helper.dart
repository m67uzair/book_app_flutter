import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationHelper {
  final FlutterLocalNotificationsPlugin _notification = FlutterLocalNotificationsPlugin();

  Future<void> initialize() async {
    var androidInitialize = AndroidInitializationSettings('mipmap/ic_launcher');

    var initializationsSettings = InitializationSettings(android: androidInitialize);
    await _notification.initialize(initializationsSettings);
  }

  Future<void> showInProgressNotification(int progress, int notificationId) async {
    AndroidNotificationDetails androidPlatformChannelSpecifics =
     AndroidNotificationDetails(
      '01',
      'channel_name',
      importance: Importance.high,
      priority: Priority.high,
      onlyAlertOnce: true,
      showProgress: true,
       progress: progress,
       maxProgress: 100,
    );
    await _notification.show(
      0,
      'Downloading PDF',
      'Download in progress... $progress%',
      NotificationDetails(android: androidPlatformChannelSpecifics),
    );
  }

  Future<void> showCompletedNotification(int notificationId) async {
    const android = AndroidNotificationDetails(
      'progress channel',
      'progress channel',
      channelDescription: 'downlaod Compelete',
      priority: Priority.high,
      importance: Importance.high,
    );
    await _notification.show(
      notificationId,
      'Download Complete',
      'PDF file downloaded successfully.',
      const NotificationDetails(android: android),
    );
  }
}
