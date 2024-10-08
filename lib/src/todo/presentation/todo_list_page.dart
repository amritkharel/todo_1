import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../authentication/application/providers/auth_provider.dart';
import '../application/providers/todo_provider.dart';
import 'edit_todo_page.dart';

class TodoListPage extends ConsumerWidget {
  const TodoListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authStateChangesProvider).maybeWhen(
          data: (user) => user,
          orElse: () => null,
        );

    if (user == null) {
      // User is not authenticated, navigate to login
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacementNamed(context, '/login');
      });
      return const SizedBox();
    }

    final todosAsyncValue = ref.watch(todoListProvider(user.uid));

    return todosAsyncValue.when(
        data: (todos) {

          return Scaffold(
            appBar: AppBar(
              title: const Text('My Tasks'),
              centerTitle: true,
              actions: [
                IconButton(
                  icon: const Icon(Icons.logout),
                  onPressed: () async {
                    await ref.read(authRepositoryProvider).signOut();
                  },
                ),
              ],
            ),
            body: ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: todos.length,
              itemBuilder: (context, index) {
                final todo = todos[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 12.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  elevation: 5,
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(16.0),
                    titleAlignment: ListTileTitleAlignment.center,
                    title: Text(
                      todo.description,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (todo.deadline != null)
                          Text(
                            'Deadline: ${DateFormat.yMMMEd().add_jm().format(todo.deadline!)}',
                            style: const TextStyle(color: Colors.black87),
                          ),
                        if (todo.reminderTime != null)
                          Text(
                            'Reminder: ${DateFormat.yMMMEd().add_jm().format(todo.reminderTime!)}',
                            style: const TextStyle(color: Colors.black54),
                          ),
                      ],
                    ),
                    trailing: Wrap(
                      spacing: 8.0,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.blueGrey),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => EditTodoPage(todo: todo),
                              ),
                            );
                          },
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.delete_outline_outlined,
                            color: Colors.red,
                            size: 25.0,
                          ),
                          onPressed: () async {
                            final confirm = await showDialog<bool>(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text('Delete Task'),
                                content: const Text(
                                    'Are you sure you want to delete this task?'),
                                actions: [
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.pop(context, false),
                                    child: const Text('Cancel'),
                                  ),
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.pop(context, true),
                                    child: const Text('Yes'),
                                  ),
                                ],
                              ),
                            );

                            if (confirm == true) {
                              // Delete the task
                              await ref
                                  .read(deleteTodoUseCaseProvider)
                                  .call(todo.id, user.uid);
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                Navigator.pushNamed(context, '/add');
              },
              child: const Icon(Icons.add),
            ),
          );
        },
        loading: () => const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            ),
        error: ((error, _) {
          return Scaffold(
            body: Center(child: Text('Error: $error')),
          );
        }));
  }
}
