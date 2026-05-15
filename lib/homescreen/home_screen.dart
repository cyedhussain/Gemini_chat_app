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
      appBar: AppBar(title: Text('Gemini ChatApp'), centerTitle: true),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              children: [
                for (var msg in messages) ItemMessages(msg: msg),
                loading
                    ? Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Text('waiting'),
                      )
                    : SizedBox(),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: msgController,
                    decoration: InputDecoration(hintText: 'enter a message'),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    if (msgController.text.isNotEmpty) {
                      sendMessage();
                    }
                  },
                  icon: Icon(CupertinoIcons.forward, color: Colors.blue),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
