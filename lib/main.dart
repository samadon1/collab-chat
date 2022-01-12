import 'package:collab_chat/chat_screen.dart';
import 'package:collab_chat/login_screen.dart';
import 'package:collab_chat/register_screen.dart';
import 'package:flutter/material.dart';
import 'welcome_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: Welcome_Screen.id,
      routes: {
        Welcome_Screen.id: (context) => Welcome_Screen(),
        Login_Screen.id: (context) => Login_Screen(),
        Register_Screen.id: (context) => Register_Screen(),
        Chat_Screen.id: (context) => Chat_Screen()
      },
    );
  }
}
