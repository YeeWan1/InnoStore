import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:inno_store/features/app/splash_screen/splash_screen.dart';
import 'package:inno_store/features/user_auth/presentations/pages/home_main.dart';
import 'package:inno_store/features/user_auth/presentations/pages/login_page.dart';
import 'package:inno_store/features/user_auth/presentations/pages/sign_up_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    if (kIsWeb) {
      await Firebase.initializeApp(
        options: FirebaseOptions(
          apiKey: "AIzaSyAFDPwZCsNSnckcq2jHvJcm7ejEhg5-2LU",
          appId: "1:396405032929:android:fa7a9d2db91884af1434a0",
          messagingSenderId: "396405032929",
          projectId: "smart-retail-app-4b6a5",
          // Your web Firebase config options
        ),
      );
    } else {
      await Firebase.initializeApp();
    }
    runApp(MyApp());
  } catch (e) {
    print('Failed to initialize Firebase: $e');
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Firebase',
      routes: {
        '/': (context) => SplashScreen(
          // Here, you can decide whether to show the LoginPage or HomePage based on user authentication
          child: LoginPage(),
        ),
        '/login': (context) => LoginPage(),
        '/signUp': (context) => SignUpPage(),
        '/home': (context) => MainHomePage(), // Ensure this is correctly implemented
      },
    );
  }
}
