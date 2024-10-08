// main.dart
import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo/src/authentication/application/providers/auth_provider.dart';
import 'package:todo/src/authentication/presentation/login_page.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:todo/src/authentication/presentation/register_page.dart';
import 'package:todo/src/todo/presentation/add_todo_page.dart';
import 'package:todo/src/todo/presentation/todo_list_page.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );  tz.initializeTimeZones();


  // Initialize FlutterLocalNotificationsPlugin
  final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  const AndroidInitializationSettings initializationSettingsAndroid =
  AndroidInitializationSettings('@mipmap/ic_launcher');

  const InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
  );

  await flutterLocalNotificationsPlugin.initialize(initializationSettings);

  // Initialize AndroidAlarmManagerPlus
  await AndroidAlarmManager.initialize();

  runApp(
    ProviderScope(
      overrides: [
        flutterLocalNotificationsPluginProvider
            .overrideWithValue(flutterLocalNotificationsPlugin),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateChangesProvider);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: {
        '/login': (context) => const LoginPage(),
        '/register': (context) => const RegisterPage(),
        '/home': (context) => const TodoListPage(),
        '/add': (context) => const AddTodoPage(),
      },
      home: authState.when(
        data: (user) {
          if (user != null) {
            return const TodoListPage();
          } else {
            return const LoginPage();
          }
        },
        loading: () => const Scaffold(
          body: Center(child: CircularProgressIndicator()),
        ),
        error: (error, stack) => Scaffold(
          body: Center(child: Text('Error: $error')),
        ),
      ),
    );
  }
}

// Provide the plugin
final flutterLocalNotificationsPluginProvider =
    Provider<FlutterLocalNotificationsPlugin>((ref) {
  throw UnimplementedError();
});

