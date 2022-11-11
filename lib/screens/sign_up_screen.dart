import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:messageme_app/screens/sign_in_screen.dart';
import 'package:messageme_app/widgets/custom_textfield.dart';
import 'package:messageme_app/widgets/custtom_button.dart';

class SignUpScreen extends StatefulWidget {
  static const String screenRoute = 'sign_up_screen';

  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  bool showSpinner = false;
  final _auth = FirebaseAuth.instance;
  late String email;
  late String password;
  void SetEmail(String value) {
    email = value;
  }

  void SetPassword(String value) {
    password = value;
  }

  @override
  Widget build(BuildContext context) {
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
                const SizedBox(height: 30),
                custom_textfield(hint: 'Enter your Email', onChanged: SetEmail),
                const SizedBox(height: 8),
                custom_textfield(
                  hint: 'Enter your Password',
                  onChanged: SetPassword,
                  isPassword: true,
                ),
                const SizedBox(height: 8),
                MyButton(
                    color: Colors.blue,
                    title: "Sign Up",
                    onPressed: () {
                      setState(() {
                        showSpinner = true;
                      });

                      try {
                        _auth
                            .createUserWithEmailAndPassword(
                                email: email, password: password)
                            .then((value) {
                          // showSpinner = false;
                          Navigator.pushNamed(
                              context, SignInScreen.screenRoute);
                        });
                      } catch (e) {
                        print(e);
                      }
                    }),
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
