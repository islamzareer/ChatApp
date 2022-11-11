import 'package:flutter/material.dart';

class MessageLine extends StatelessWidget {
  final String text;
  final String sender;
  final bool isSender;
  const MessageLine(
      {required this.sender,
      required this.text,
      required this.isSender,
      super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      child: Column(
          crossAxisAlignment:
              isSender ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            Text(
              sender,
              style: TextStyle(
                  color: isSender ? Colors.blue[900] : Colors.yellow[900],
                  fontSize: 10),
            ),
            Material(
                elevation: 5,
                color: isSender ? Colors.yellow[900] : Colors.blue[800],
                borderRadius: isSender
                    ? const BorderRadius.only(
                        topLeft: Radius.circular(30),
                        bottomRight: Radius.circular(30),
                        bottomLeft: Radius.circular(30),
                      )
                    : const BorderRadius.only(
                        topRight: Radius.circular(30),
                        bottomRight: Radius.circular(30),
                        bottomLeft: Radius.circular(30),
                      ),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Text(text,
                      style:
                          const TextStyle(color: Colors.white, fontSize: 15)),
                ))
          ]),
    );
  }
}
