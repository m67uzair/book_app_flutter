import 'package:flutter/cupertino.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationHelper extends ChangeNotifier{
  final FlutterLocalNotificationsPlugin _notification = FlutterLocalNotificationsPlugin();

  Future<void> initialize() async {
    var androidInitialize = AndroidInitializationSettings('mipmap/ic_launcher');

    var initializationsSettings = InitializationSettings(android: androidInitialize);
    await _notification.initialize(initializationsSettings);
  }

  Future<void> showInProgressNotification(
      int progress, String totalSize, String downloadedSize, int notificationId, String fileName) async {
    AndroidNotificationDetails androidPlatformChannelSpecifics = AndroidNotificationDetails(
      '01',
      'progress channel',
      importance: Importance.high,
      priority: Priority.high,
      onlyAlertOnce: true,
      showProgress: true,
      progress: progress,
      maxProgress: 100,
    );
    await _notification.show(
      notificationId,
      'Downloading $fileName',
      'Download in progress... $downloadedSize / $totalSize $progress%',
      NotificationDetails(android: androidPlatformChannelSpecifics),
    );
  }

  Future<void> cancelInProgressNotification(int notificationId) async {
    await _notification.cancel(notificationId);
  }

  Future<void> showCompletedNotification(int notificationId, String fileName) async {
    AndroidNotificationDetails androidPlatformChannelSpecifics = const AndroidNotificationDetails(
      '02',
      'progress channel',
      importance: Importance.high,
      priority: Priority.high,
      playSound: true,
    );
    await _notification.show(
      notificationId,
      'Download Complete',
      '$fileName downloaded successfully.',
      NotificationDetails(android: androidPlatformChannelSpecifics),
    );
  }
}
