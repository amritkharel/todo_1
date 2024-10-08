import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../../../todo/domain/entities/todo.dart';

class NotificationDataSource {
  Future<void> scheduleNotification(Todo todo) async {
    if (todo.reminderTime != null) {
      final DateTime scheduledDate = todo.reminderTime!;

      await AndroidAlarmManager.oneShotAt(
        scheduledDate,
        todo.id.hashCode,
        showNotificationCallback,
        exact: true,
        wakeup: true,
        rescheduleOnReboot: true,
        params: {
          'id': todo.id.hashCode,
          'title': 'Todo Reminder',
          'body': todo.description,
        },
      );
    }
  }

  Future<void> cancelNotification(String todoId) async {
    await AndroidAlarmManager.cancel(todoId.hashCode);
  }
}

@pragma('vm:entry-point')
void showNotificationCallback(int id, Map<String, dynamic> params) async {
  final String title = params['title'];
  final String body = params['body'];

  final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');

  const InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
  );

  await flutterLocalNotificationsPlugin.initialize(initializationSettings);

  var androidDetails = const AndroidNotificationDetails(
    'todo_channel',
    'Todo Notifications',
    channelDescription: 'Reminders for your todos',
    importance: Importance.max,
    priority: Priority.high,
  );

  var notificationDetails = NotificationDetails(android: androidDetails);

  await flutterLocalNotificationsPlugin.show(
    id,
    title,
    body,
    notificationDetails,
  );
}
