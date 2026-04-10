import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:myapp/home_screen.dart';
import 'package:myapp/login_screen.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Appointment Booking',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF0288D1), // Bright Medical Blue
          primary: const Color(0xFF0277BD), // Deep Ocean Blue
          secondary: const Color(0xFF26A69A), // Refreshing Teal
          tertiary: const Color(0xFF5C6BC0), // Soft Indigo
        ),
        useMaterial3: true,
        textTheme: const TextTheme(titleMedium: TextStyle(letterSpacing: -0.3)),
        appBarTheme: const AppBarTheme(scrolledUnderElevation: 0),
      ),
      initialRoute: '/login',
      routes: {
        '/login': (context) => const LoginScreen(),
        '/home': (context) => const HomeScreen(),
      },
    );
  }
}
