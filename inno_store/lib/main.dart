// lib/main.dart

import 'package:flutter/material.dart';
import 'first.dart'; // Import the first.dart file
import 'login.dart'; // Import the login.dart file

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Navigation Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/', // Set SplashScreen as the initial route
      routes: {
        '/': (context) => const SplashScreen(), // Show SplashScreen first
        '/login': (context) => const LoginPage(), // Show LoginPage after SplashScreen
        // Define other routes as needed
        // '/home': (context) => HomePage(),
        // '/profile': (context) => const ProfilePage(username: '',),
      },
    );
  }
}
