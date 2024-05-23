import 'package:expense/provider/provider.dart';
import 'package:expense/provider/repository.dart';
import 'package:expense/view/expense_screen.dart';
import 'package:expense/view/login.dart';
import 'package:expense/view/registration.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'data/hive.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    await Firebase.initializeApp(
        options: const FirebaseOptions(
            apiKey: "AIzaSyAeydVVwrRM_OW1FQ2h-BGGZPe14G8GtkU",
            appId: "1:7115928125:web:90e76360be41f236ed3054",
            messagingSenderId: "G-RVY3KEEWPL",
            projectId: "expense-e365c")
    );

  }else{
    await Firebase.initializeApp(
        options: const FirebaseOptions(
            apiKey: "AIzaSyAeydVVwrRM_OW1FQ2h-BGGZPe14G8GtkU",
            appId: "1:7115928125:web:90e76360be41f236ed3054",
            messagingSenderId: "G-RVY3KEEWPL",
            projectId: "expense-e365c")
    );

  }
  await Hive.initFlutter();
  Hive.registerAdapter(ExpenseAdapter());
  await Hive.openBox<Expense>('expenses');

  runApp(
    ChangeNotifierProvider(
      create: (context) =>
          ExpenseProvider(HiveExpenseRepository(Hive.box('expenses'))),
      child: MyApp(),
    ),
  );

  scheduleDailyExpenseReminder();
}

class MyApp extends StatelessWidget {
  final Future<FirebaseApp> _fApp = Firebase.initializeApp();

   MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Expense Tracker',
      theme: ThemeData(
        appBarTheme: const AppBarTheme(
          color: Color(0xFF283593), // Dark Blue for AppBar
        ),
        scaffoldBackgroundColor:
            Color(0xFFF3F3F3), // Light Grey for Scaffold background
      ),
      initialRoute: "/",
      routes: {
        '/': (context) => AuthCheck(),
        '/register': (context) => RegisterScreen(),
        '/home': (context) => const ExpenseListScreen(),
      },
      // home: ExpenseListScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

void scheduleDailyExpenseReminder() async {
  final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
    'daily_expense_reminder',
    'Daily Expense Reminder',
    importance: Importance.high,
    priority: Priority.high,
    showWhen: false,
  );
  const NotificationDetails notificationDetails =
      NotificationDetails(android: androidDetails);

  await flutterLocalNotificationsPlugin.showDailyAtTime(
      0,
      'Record your expenses',
      'Don\'t forget to log your expenses for today!',
       const Time(20, 0, 0),// Schedule for 8 PM
      notificationDetails);
}
class AuthCheck extends StatelessWidget {
  const AuthCheck({super.key});

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      return const ExpenseListScreen();
    } else {
      return const SignInScreen();
    }
  }
}