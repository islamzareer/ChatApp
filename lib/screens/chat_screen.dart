import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:messageme_app/screens/sign_in_screen.dart';
import 'package:messageme_app/widgets/message_line.dart';
import 'package:messageme_app/widgets/messages_stream_builder.dart';

class ChatScreen extends StatefulWidget {
  static const screenRoute = "/ChatScreen";
  ChatScreen({Key? key}) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final messageEditingController = TextEditingController();
  late User signedInUser;

  final _auth = FirebaseAuth.instance;
  final _fireStore = FirebaseFirestore.instance;
  bool doneGetUser = false;

  String? messageText;
  getCurrentUser() async {
    try {
      final user = await _auth.currentUser;
      if (user != null) {
        setState(() {
          signedInUser = user;
          doneGetUser = true;
        });

        print(signedInUser.email);
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    getCurrentUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.yellow[900],
            title: Row(
              children: [
                Image.asset('assets/logo.png', height: 25),
                const SizedBox(width: 10),
                const Text('Chat')
              ],
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    _auth.signOut();
                    Navigator.pushNamed(context, SignInScreen.screenRoute);
                  },
                  child: const Text(
                    "LogOut",
                    style: TextStyle(color: Colors.white),
                  ))
            ],
          ),
          body: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                doneGetUser
                    ? MessagesStreamBuilder(
                        fireStore: _fireStore,
                        signedInUser: signedInUser,
                      )
                    : const CircularProgressIndicator(),
                Container(
                  decoration: const BoxDecoration(
                    border: Border(
                      top: BorderSide(
                        color: Colors.orange,
                        width: 2,
                      ),
                    ),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: TextField(
                          controller: messageEditingController,
                          onChanged: (value) {
                            setState(() {
                              messageText = value;
                            });
                          },
                          decoration: const InputDecoration(
                            contentPadding: EdgeInsets.symmetric(
                              vertical: 10,
                              horizontal: 20,
                            ),
                            hintText: 'Write your message here...',
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          messageEditingController.clear();
                          _fireStore.collection("messages").add({
                            'sender': signedInUser.email,
                            'text': messageText,
                            'time': FieldValue.serverTimestamp()
                          });
                        },
                        child: Text(
                          'send',
                          style: TextStyle(
                            color: Colors.blue[800],
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

