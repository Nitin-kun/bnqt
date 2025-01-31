import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:lakebenquet/login/loginscreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Indian Banquet Hall',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: Colors.orange, // Rich gold color
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: Colors.amber,
          accentColor: Colors.amberAccent,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor:
                const Color(0xFFB8860B), // Rich gold color for buttons
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            textStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          ),
        ),
        textTheme: const TextTheme(
          displayLarge: TextStyle(
            fontSize: 28.0,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
          bodyLarge: TextStyle(
            fontSize: 16.0,
            color: Colors.black87,
          ),
          titleMedium: TextStyle(
            fontSize: 18.0,
            fontWeight: FontWeight.w500,
            color: Color.fromARGB(
                255, 255, 183, 0), // Rich gold for text highlights
          ),
        ),
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: const AppBarTheme(
          backgroundColor:
              Color.fromARGB(255, 255, 184, 6), // Rich gold app bar color
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        useMaterial3: true,
      ),
      home: const LoginScreen(),
    );
  }
}
