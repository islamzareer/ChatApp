import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:messageme_app/screens/chat_screen.dart';
import 'package:messageme_app/screens/sign_in_screen.dart';
import 'package:messageme_app/screens/sign_up_screen.dart';
import 'package:messageme_app/screens/welcome_screen.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    print(e);
  }
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final _auth = FirebaseAuth.instance;

  MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'MessageMe ',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        initialRoute: _auth.currentUser != null
            ? ChatScreen.screenRoute
            : WelcomeScreen.screenRoute,
        routes: {
          WelcomeScreen.screenRoute: (context) => const WelcomeScreen(),
          SignInScreen.screenRoute: (context) => const SignInScreen(),
          SignUpScreen.screenRoute: (context) => const SignUpScreen(),
          ChatScreen.screenRoute: (context) => ChatScreen(),
        });
  }
}
