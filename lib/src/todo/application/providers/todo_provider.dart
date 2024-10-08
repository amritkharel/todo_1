import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo/src/todo/domain/usecases/delete_todo_usecase.dart';
import '../../data/datasources/notification_datasource.dart';
import '../../data/repositories/notification_repository_impl.dart';
import '../../domain/entities/todo.dart';
import '../../domain/repositories/notification_repository.dart';
import '../../domain/repositories/todo_repository.dart';
import '../../data/datasources/firebase_todo_datasource.dart';
import '../../data/repositories/todo_repository_impl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/usecases/add_todo_usecase.dart';
import '../../domain/usecases/update_todo_usecase.dart';

//todo provider and notification provider

final firestoreProvider = Provider<FirebaseFirestore>((ref) {
  return FirebaseFirestore.instance;
});

final firebaseTodoDataSourceProvider = Provider<FirebaseTodoDataSource>((ref) {
  return FirebaseTodoDataSource(ref.read(firestoreProvider));
});

final todoRepositoryProvider = Provider<TodoRepository>((ref) {
  return TodoRepositoryImpl(ref.read(firebaseTodoDataSourceProvider));
});

final todoListProvider =
    StreamProvider.family<List<Todo>, String>((ref, userId) {
  return ref.read(todoRepositoryProvider).getTodos(userId);
});

final addTodoUseCaseProvider = Provider<AddTodoUseCase>((ref) {
  return AddTodoUseCase(
    todoRepository: ref.read(todoRepositoryProvider),
    notificationRepository: ref.read(notificationRepositoryProvider),
  );
});

final deleteTodoUseCaseProvider = Provider<DeleteTodoUseCase>((ref) {
  return DeleteTodoUseCase(
      todoRepository: ref.read(todoRepositoryProvider),
      notificationRepository: ref.read(notificationRepositoryProvider));
});

final updateTodoUseCaseProvider = Provider<UpdateTodoUseCase>((ref) {
  return UpdateTodoUseCase(
    todoRepository: ref.read(todoRepositoryProvider),
    notificationRepository: ref.read(notificationRepositoryProvider),
  );
});

final flutterLocalNotificationsPluginProvider =
    Provider<FlutterLocalNotificationsPlugin>((ref) {
  return FlutterLocalNotificationsPlugin();
});

final notificationDataSourceProvider = Provider<NotificationDataSource>((ref) {
  return NotificationDataSource();
});

final notificationRepositoryProvider = Provider<NotificationRepository>((ref) {
  return NotificationRepositoryImpl(
      dataSource: ref.read(notificationDataSourceProvider));
});
