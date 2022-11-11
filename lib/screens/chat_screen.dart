import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:messageme_app/widgets/message_line.dart';

class ChatScreen extends StatefulWidget {
  static const screenRoute = "/ChatScreen";
  ChatScreen({Key? key}) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

late User signedInUser;

class _ChatScreenState extends State<ChatScreen> {
  final messageEditingController = TextEditingController();

  final _auth = FirebaseAuth.instance;
  final _fireStore = FirebaseFirestore.instance;

  String? messageText;
  getCurrentUser() async {
    try {
      final user = await _auth.currentUser;
      if (user != null) {
        setState(() {
          signedInUser = user;
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
                    Navigator.pop(context);
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
                MessagesStreamBuilder(fireStore: _fireStore),
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

class MessagesStreamBuilder extends StatelessWidget {
  late FirebaseFirestore fireStore;

  MessagesStreamBuilder({required this.fireStore});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: fireStore.collection('messages').orderBy('time').snapshots(),
        builder: (context, snapshot) {
          List<MessageLine> messageWidgets = [];
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(
                color: Colors.orange,
              ),
            );
          }
          final messages = snapshot.data!.docs.reversed;
          for (var message in messages) {
            final messageText = message.get('text');
            final messageEmail = message.get('sender');
            final messageWidget = MessageLine(
              sender: messageEmail,
              text: messageText,
              isSender: messageEmail == signedInUser.email ? true : false,
            );

            messageWidgets.add(messageWidget);
          }
          return Expanded(
            child: ListView.builder(
              reverse: true,
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
              itemCount: messageWidgets.length,
              itemBuilder: (context, index) {
                return messageWidgets[index];
              },
            ),
          );
        });
  }
}
