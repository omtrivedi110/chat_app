import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class Notification_Helper {
  Notification_Helper._();

  static final Notification_Helper notification_helper =
      Notification_Helper._();
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  initNotification() async {
    flutterLocalNotificationsPlugin.initialize(
      const InitializationSettings(
        android: AndroidInitializationSettings('@mipmap/ic_launcher'),
        iOS: DarwinInitializationSettings(),
      ),
    );
  }

  simpleNotification({required String mail, required String msg}) {
    AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(mail, "${mail}123");

    DarwinNotificationDetails darwinNotificationDetails =
        DarwinNotificationDetails(
      subtitle: mail,
    );
    flutterLocalNotificationsPlugin.show(
      101,
      msg,
      "${mail}123",
      NotificationDetails(
        android: androidNotificationDetails,
        iOS: darwinNotificationDetails,
      ),
    );
  }
}
