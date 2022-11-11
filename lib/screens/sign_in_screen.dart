import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:messageme_app/screens/chat_screen.dart';
import 'package:messageme_app/widgets/custom_textfield.dart';
import 'package:messageme_app/widgets/custtom_button.dart';

class SignInScreen extends StatefulWidget {
  static const String screenRoute = 'signin_screen';

  const SignInScreen({Key? key}) : super(key: key);

  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _auth = FirebaseAuth.instance;
  late String email;
  late String password;
  void getEmail(String value) {
    email = value;
  }

  void getPassword(String value) {
    password = value;
  }

  @override
  Widget build(BuildContext context) {
    bool showSpinner = false;
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(
                  height: 100,
                ),
                SizedBox(
                  height: 180,
                  child: Image.asset('assets/logo.png'),
                ),
                const SizedBox(height: 50),
                custom_textfield(
                  hint: "Enter Your Email",
                  onChanged: getEmail,
                ),
                const SizedBox(height: 8),
                custom_textfield(
                  hint: "Enter Your Password",
                  onChanged: getPassword,
                  isPassword: true,
                ),
                const SizedBox(height: 10),
                MyButton(
                  color: Colors.yellow[900]!,
                  title: 'Sign in',
                  onPressed: () async {
                    setState(() {
                      showSpinner = true;
                    });
                    try {
                      final _user = await _auth.signInWithEmailAndPassword(
                          email: email, password: password);
                      if (_user != null) {
                        Navigator.pushNamed(context, ChatScreen.screenRoute);
                      }
                    } catch (e) {
                      print("Error: " + e.toString());
                    }
                  },
                ),
                Center(
                  child: showSpinner
                      ? const CircularProgressIndicator()
                      : const SizedBox(),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
