import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:messageme_app/widgets/message_line.dart';

class MessagesStreamBuilder extends StatelessWidget {
  late FirebaseFirestore fireStore;
  late User signedInUser;

  MessagesStreamBuilder({required this.fireStore, required this.signedInUser});

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
