import '../repositories/notification_repository.dart';
import '../repositories/todo_repository.dart';

class DeleteTodoUseCase {
  final TodoRepository todoRepository;
  final NotificationRepository notificationRepository;

  DeleteTodoUseCase({
    required this.todoRepository,
    required this.notificationRepository,
  });

  Future<void> call(String todoId, String userId) async {
    await todoRepository.deleteTodo(todoId, userId);
    await notificationRepository.cancelNotification(todoId);
  }
}
