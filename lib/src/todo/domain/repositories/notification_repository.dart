import '../entities/todo.dart';

abstract class NotificationRepository {
  Future<void> scheduleNotification(Todo todo);

  Future<void> cancelNotification(String todoId);
}
