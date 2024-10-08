class Todo {
  final String id;
  final String userId;
  final String description;
  final DateTime? deadline;
  final DateTime? reminderTime;
  final DateTime createdTime;

  Todo({
    required this.id,
    required this.userId,
    required this.description,
    this.deadline,
    this.reminderTime,
    required this.createdTime,
  });

  // Add copyWith method for convenience
  Todo copyWith({
    String? id,
    String? userId,
    String? description,
    DateTime? deadline,
    DateTime? reminderTime,
    DateTime? createdTime,
  }) {
    return Todo(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      description: description ?? this.description,
      deadline: deadline ?? this.deadline,
      reminderTime: reminderTime ?? this.reminderTime,
      createdTime: createdTime ?? this.createdTime,
    );
  }
}
