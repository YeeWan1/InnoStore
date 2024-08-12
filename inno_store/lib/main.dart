import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:inno_store/features/app/splash_screen/splash_screen.dart';
import 'package:inno_store/features/user_auth/presentations/pages/home_main.dart';
import 'package:inno_store/features/user_auth/presentations/pages/login_page.dart';
import 'package:inno_store/features/user_auth/presentations/pages/sign_up_page.dart';
import 'package:inno_store/Customer_Support/customer_support_screen.dart';
import 'package:inno_store/Cashier/pay.dart';
import 'package:inno_store/my_account_page/purchase_history.dart';
import 'package:inno_store/Cashier/cart_item.dart';

ValueNotifier<List<Offset>> pathNotifier = ValueNotifier<List<Offset>>([]);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeFirebase();
  runApp(MyApp());
}

Future<void> initializeFirebase() async {
  try {
    if (Firebase.apps.isEmpty) {
      await Firebase.initializeApp(
        options: FirebaseOptions(
          apiKey: "AIzaSyAFDPwZCsNSnckcq2jHvJcm7ejEhg5-2LU",
          appId: "1:396405032929:android:fa7a9d2db91884af1434a0",
          messagingSenderId: "396405032929",
          projectId: "smart-retail-app-4b6a5",
          storageBucket: "smart-retail-app-4b6a5.appspot.com",
          databaseURL: "https://smart-retail-app-4b6a5-default-rtdb.asia-southeast1.firebasedatabase.app",
        ),
      );
    }
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
      initialRoute: '/signUp',  // Set the initial route to the sign-up page
      routes: {
        '/': (context) => SplashScreen(),
        '/login': (context) => LoginPage(),
        '/signUp': (context) => SignUpPage(),
        '/home': (context) => MainHomePage(pathNotifier: pathNotifier),
        '/customerSupport': (context) => CustomerSupportScreen(),
        '/pay': (context) => PayScreen(cartItems: [], username: '', onClearCart: () {}),
        '/purchaseHistory': (context) => PurchaseHistoryPage(),
      },
    );
  }
}
