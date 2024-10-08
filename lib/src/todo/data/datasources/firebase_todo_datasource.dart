import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/todo_model.dart';

class FirebaseTodoDataSource {
  final FirebaseFirestore firestore;

  FirebaseTodoDataSource(this.firestore);

  Stream<List<TodoModel>> getTodos(String userId) {
    return firestore
        .collection('todos')
        .doc(userId)
        .collection('userTodos')
        .orderBy("createddTime", descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => TodoModel.fromMap(doc.data(), doc.id))
            .toList());
  }

  Future<void> addTodo(TodoModel todo) async {
    await firestore
        .collection('todos')
        .doc(todo.userId)
        .collection('userTodos')
        .add(todo.toMap());
  }

  Future<void> updateTodo(TodoModel todo) async {
    await firestore
        .collection('todos')
        .doc(todo.userId)
        .collection('userTodos')
        .doc(todo.id)
        .update(todo.toMap());
  }

  Future<void> deleteTodo(String id, String userId) async {
    await firestore
        .collection('todos')
        .doc(userId)
        .collection('userTodos')
        .doc(id)
        .delete();
  }
}
