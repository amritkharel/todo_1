import '../../domain/entities/todo.dart';

class TodoModel extends Todo {
  TodoModel({
    required String id,
    required String userId,
    required String description,
    DateTime? deadline,
    DateTime? reminderTime,
    required DateTime createdTime,
  }) : super(
            id: id,
            userId: userId,
            description: description,
            deadline: deadline,
            reminderTime: reminderTime,
            createdTime: createdTime);

  factory TodoModel.fromMap(Map<String, dynamic> map, String id) {
    return TodoModel(
      id: id,
      userId: map['userId'],
      description: map['description'],
      deadline: map['deadline'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['deadline'])
          : null,
      reminderTime: map['reminderTime'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['reminderTime'])
          : null,
      createdTime: map['createdTime'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['createdTime'])
          : DateTime.now(),
    );
  }

  factory TodoModel.fromEntity(Todo todo) {
    return TodoModel(
      id: todo.id,
      userId: todo.userId,
      description: todo.description,
      deadline: todo.deadline,
      reminderTime: todo.reminderTime,
      createdTime: todo.createdTime,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'description': description,
      'deadline': deadline?.millisecondsSinceEpoch,
      'reminderTime': reminderTime?.millisecondsSinceEpoch,
      'createddTime': createdTime.millisecondsSinceEpoch,
    };
  }
}
