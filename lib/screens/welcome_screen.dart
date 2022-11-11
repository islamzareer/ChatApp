import 'package:flutter/material.dart';
import 'package:messageme_app/screens/sign_in_screen.dart';
import 'package:messageme_app/screens/sign_up_screen.dart';
import 'package:messageme_app/widgets/custtom_button.dart';

class WelcomeScreen extends StatefulWidget {
  static const String screenRoute = '/WelcomeScreen';

  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Column(
                children: const [
                  SizedBox(
                    height: 180,
                    child: Image(image: AssetImage("assets/logo.png")),
                  ),
                  Text(
                    'MessageMe',
                    style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.w900,
                      color: Color(0xff2e386b),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              MyButton(
                color: Colors.yellow[800]!,
                title: 'Sign In',
                onPressed: () {
                  Navigator.pushNamed(context, SignInScreen.screenRoute);
                },
              ),
              MyButton(
                color: Colors.blue[800]!,
                title: 'Sign Up',
                onPressed: () {
                  Navigator.pushNamed(context, SignUpScreen.screenRoute);
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
