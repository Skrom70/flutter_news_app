import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_news_app/pages/authentication/forgot_password_page.dart';
import 'package:flutter_news_app/pages/authentication/login_page.dart';
import 'package:flutter_news_app/pages/authentication/register_page.dart';
import 'package:flutter_news_app/firebase_support/firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_news_app/provider/data_provider.dart';
import 'pages/home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home:
          FirebaseAuth.instance.currentUser != null ? HomePage() : LoginPage(),
      routes: {
        '/login': (_) => LoginPage(),
        '/register': (_) => RegisterPage(),
        '/forgot_password': (_) => ForgotPassword(),
        '/home': (_) => HomePage(),
      },
    );
  }
}