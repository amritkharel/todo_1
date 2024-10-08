import '../entities/todo.dart';
import '../repositories/notification_repository.dart';
import '../repositories/todo_repository.dart';

class AddTodoUseCase {
  final TodoRepository todoRepository;
  final NotificationRepository notificationRepository;

  AddTodoUseCase({
    required this.todoRepository,
    required this.notificationRepository,
  });

  Future<void> call(Todo todo) async {
    if (todo.description.isEmpty) {
      throw Exception('Description cannot be empty');
    }

    await todoRepository.addTodo(todo);

    if (todo.reminderTime != null) {
      await notificationRepository.scheduleNotification(todo);
    }
  }
}
