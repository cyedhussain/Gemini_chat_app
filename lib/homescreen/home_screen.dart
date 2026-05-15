import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gemini_chat_app/homescreen/widgets/item_messages.dart';
import 'package:gemini_chat_app/model/message_model.dart';
import 'package:http/http.dart' as http;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String url =
      "https://generativelanguage.googleapis.com/v1beta/models/gemini-3-flash-preview:generateContent";
  final msgController = TextEditingController();
  bool loading = false;
  List<MessageModel> messages = [];

  sendMessage() async {
    String msg = msgController.text;
    msgController.clear();
    // ignore: unused_local_variable
    setState(() {
      messages.add(MessageModel(true, msg));
      loading = true;
    });
    try {
      // ignore: unused_local_variable
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'x-goog-api-key': '',
        },
        body: jsonEncode({
          'contents': [
            {
              'parts': [
                {'text': msg},
              ],
            },
          ],
        }),
      );
      final data = jsonDecode(response.body);
      String botResponse = data['candidates'][0]['content']['parts'][0]['text'];
      setState(() {
        messages.add(MessageModel(false, botResponse));
      });
    } catch (e) {
      print(e.toString());
    } finally {
      setState(() {
        loading = false;
      });
    }
  }

 @override
Widget build(BuildContext context) {
  return Scaffold(
    backgroundColor: const Color(0xffF5F7FB),

    appBar: AppBar(
      elevation: 0,
      backgroundColor: Colors.white,
      centerTitle: true,
      title: const Text(
        "Gemini AI",
        style: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
        ),
      ),
    ),

    body: Column(
      children: [

        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.only(top: 12, bottom: 12),
            itemCount: messages.length,
            itemBuilder: (context, index) {
              return ItemMessages(msg: messages[index]);
            },
          ),
        ),

        if (loading)
          Padding(
            padding: const EdgeInsets.only(left: 20, bottom: 10),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 14,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.pink.shade300,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        width: 6,
                        height: 6,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(width: 10),
                      Text(
                        "Typing...",
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

        SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [

                  Expanded(
                    child: TextField(
                      controller: msgController,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: "Ask anything...",
                      ),
                    ),
                  ),

                  GestureDetector(
                    onTap: () {
                      if (msgController.text.isNotEmpty) {
                        sendMessage();
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          colors: [
                            Color(0xff4A90E2),
                            Color(0xff357ABD),
                          ],
                        ),
                      ),
                      child: const Icon(
                        Icons.send,
                        color: Colors.white,
                      ),
                    ),
                  ),

                ],
              ),
            ),
          ),
        ),

      ],
    ),
  );
}
}