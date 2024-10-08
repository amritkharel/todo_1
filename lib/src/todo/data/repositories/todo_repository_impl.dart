import '../../domain/repositories/todo_repository.dart';
import '../../domain/entities/todo.dart';
import '../datasources/firebase_todo_datasource.dart';
import '../models/todo_model.dart';

class TodoRepositoryImpl implements TodoRepository {
  final FirebaseTodoDataSource dataSource;

  TodoRepositoryImpl(this.dataSource);

  @override
  Stream<List<Todo>> getTodos(String userId) {
    return dataSource.getTodos(userId).map((todoModels) {
      return todoModels.map((todoModel) => todoModel as Todo).toList();
    });
  }

  @override
  Future<void> addTodo(Todo todo) async {
    final todoModel = TodoModel(
      id: '',
      userId: todo.userId,
      description: todo.description,
      deadline: todo.deadline,
      reminderTime: todo.reminderTime,
      createdTime: todo.createdTime,
    );
    await dataSource.addTodo(todoModel);
  }

  @override
  Future<void> updateTodo(Todo todo) async {
    final todoModel = TodoModel(
      id: todo.id,
      userId: todo.userId,
      description: todo.description,
      deadline: todo.deadline,
      reminderTime: todo.reminderTime,
      createdTime: todo.createdTime,
    );
    await dataSource.updateTodo(todoModel);
  }

  @override
  Future<void> deleteTodo(String id, String userId) async {
    await dataSource.deleteTodo(id, userId);
  }
}
