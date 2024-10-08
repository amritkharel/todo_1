import '../../domain/repositories/notification_repository.dart';
import '../datasources/notification_datasource.dart';
import '../../../todo/domain/entities/todo.dart';

class NotificationRepositoryImpl implements NotificationRepository {
  final NotificationDataSource dataSource;

  NotificationRepositoryImpl({required this.dataSource});

  @override
  Future<void> scheduleNotification(Todo todo) async {
    await dataSource.scheduleNotification(todo);
  }

  @override
  Future<void> cancelNotification(String todoId) async {
    await dataSource.cancelNotification(todoId);
  }
}
