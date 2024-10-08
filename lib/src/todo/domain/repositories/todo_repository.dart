import '../entities/todo.dart';

abstract class TodoRepository {
  Stream<List<Todo>> getTodos(String userId);

  Future<void> addTodo(Todo todo);

  Future<void> updateTodo(Todo todo);

  Future<void> deleteTodo(String id, String userId);
}
