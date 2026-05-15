import 'package:flutter/material.dart';
import 'package:gemini_chat_app/model/message_model.dart';

class ItemMessages extends StatelessWidget {
  final MessageModel msg;
  const ItemMessages({super.key, required this.msg});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: msg.isUser
          ? AlignmentGeometry.centerRight
          : AlignmentGeometry.centerLeft,
      child: Container(
        constraints: BoxConstraints(maxWidth: 300),
        padding: EdgeInsets.all(15),
        margin: EdgeInsets.all(15),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: msg.isUser ? Colors.blue : Colors.pinkAccent,
        ),
        child: Text(msg.text, style: TextStyle(color: Colors.white)),
      ),
    );
  }
}
