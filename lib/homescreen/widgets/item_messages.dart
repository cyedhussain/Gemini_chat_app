import 'package:flutter/material.dart';
import 'package:gemini_chat_app/model/message_model.dart';

class ItemMessages extends StatelessWidget {
  final MessageModel msg;

  const ItemMessages({super.key, required this.msg});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: Row(
        mainAxisAlignment:
            msg.isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 18,
                vertical: 14,
              ),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: msg.isUser
                      ? [
                          Color(0xff4A90E2),
                          Color(0xff357ABD),
                        ]
                      : [
                          Color(0xffFF7EB3),
                          Color(0xffFF4F9A),
                        ],
                ),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                  bottomLeft: Radius.circular(msg.isUser ? 24 : 4),
                  bottomRight: Radius.circular(msg.isUser ? 4 : 24),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Text(
                msg.text,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  height: 1.5,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}