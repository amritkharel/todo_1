import '../../domain/entities/todo.dart';
import '../../domain/repositories/todo_repository.dart';
import '../repositories/notification_repository.dart';

class UpdateTodoUseCase {
  final TodoRepository todoRepository;
  final NotificationRepository notificationRepository;

  UpdateTodoUseCase({
    required this.todoRepository,
    required this.notificationRepository,
  });

  Future<void> call(Todo todo) async {
    if (todo.description.isEmpty) {
      throw Exception('Description cannot be empty');
    }

    // Update the todo in the repository
    await todoRepository.updateTodo(todo);

    // Cancel any existing notification
    await notificationRepository.cancelNotification(todo.id);

    // Schedule a new notification if reminderTime is set
    if (todo.reminderTime != null) {
      try {
        await notificationRepository.scheduleNotification(todo);
      } catch (e) {
        rethrow;
      }
    }
  }
}
