import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart'; // Make sure to import this if not already
import '../../authentication/application/providers/auth_provider.dart';
import '../domain/entities/todo.dart';
import '../application/providers/todo_provider.dart';

class AddTodoPage extends ConsumerStatefulWidget {
  const AddTodoPage({super.key});

  @override
  _AddTodoPageState createState() => _AddTodoPageState();
}

class _AddTodoPageState extends ConsumerState<AddTodoPage> {
  final _formKey = GlobalKey<FormState>();
  String _description = '';
  DateTime? _deadline;
  DateTime? _reminderTime;
  bool _isLoading = false; // Added to track loading state

  @override
  Widget build(BuildContext context) {
    final userAsyncValue = ref.watch(authStateChangesProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Task'),
        centerTitle: true,
      ),
      body: userAsyncValue.when(
        data: (user) {
          if (user == null) {
            return const Center(child: Text('User not logged in'));
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'Description',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.description),
                        ),
                        validator: (value) =>
                            value == null || value.isEmpty ? 'Required' : null,
                        onSaved: (value) => _description = value!,
                      ),
                      const SizedBox(height: 16),
                      ListTile(
                        leading: const Icon(Icons.calendar_today),
                        title: Text(_deadline != null
                            ? 'Deadline: ${DateFormat.yMMMEd().add_jm().format(_deadline!)}'
                            : 'Set Deadline'),
                        onTap: _pickDeadline,
                      ),
                      const SizedBox(height: 8),
                      ListTile(
                        leading: const Icon(Icons.alarm),
                        title: Text(_reminderTime != null
                            ? 'Reminder: ${DateFormat.yMMMEd().add_jm().format(_reminderTime!)}'
                            : 'Set Reminder'),
                        onTap: _pickReminderTime,
                      ),
                      const SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : _saveTask,
                          // Disable button when loading
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            foregroundColor: Colors.white,
                            backgroundColor: Colors.blueGrey,
                            elevation: 5.0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          child: _isLoading
                              ? const SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  ),
                                )
                              : const Text(
                                  'Add Task',
                                  style: TextStyle(fontSize: 18),
                                ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: ${e.toString()}')),
      ),
    );
  }

  Future<void> _pickDeadline() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _deadline ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (pickedDate != null) {
      TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(_deadline ?? DateTime.now()),
      );
      if (pickedTime != null) {
        setState(() {
          _deadline = DateTime(
            pickedDate.year,
            pickedDate.month,
            pickedDate.day,
            pickedTime.hour,
            pickedTime.minute,
          );

          // If reminder time is after deadline, reset it
          if (_reminderTime != null && _reminderTime!.isAfter(_deadline!)) {
            _reminderTime = null;
          }
        });
      }
    }
  }

  Future<void> _pickReminderTime() async {
    if (_deadline == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Set a deadline first')),
      );
      return;
    }
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _reminderTime ?? _deadline!,
      firstDate: DateTime.now(),
      lastDate: _deadline!,
    );
    if (pickedDate != null) {
      TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(_reminderTime ?? DateTime.now()),
      );
      if (pickedTime != null) {
        setState(() {
          _reminderTime = DateTime(
            pickedDate.year,
            pickedDate.month,
            pickedDate.day,
            pickedTime.hour,
            pickedTime.minute,
          );
        });
      }
    }
  }

  Future<void> _saveTask() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final user = ref.read(authStateChangesProvider).asData?.value;

      if (user != null) {
        final todo = Todo(
          id: '',
          // The repository will generate the ID
          userId: user.uid,
          description: _description,
          deadline: _deadline,
          reminderTime: _reminderTime,
          createdTime: DateTime.now(),
        );

        setState(() {
          _isLoading = true; // Set loading state to true
        });

        try {
          await ref.read(addTodoUseCaseProvider).call(todo);
          Navigator.pop(context);
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: ${e.toString()}')),
          );
        } finally {
          if (mounted) {
            setState(() {
              _isLoading = false; // Set loading state back to false
            });
          }
        }
      }
    }
  }
}
