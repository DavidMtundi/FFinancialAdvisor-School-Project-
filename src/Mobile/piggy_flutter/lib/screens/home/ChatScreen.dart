//
import 'package:flutter/material.dart';
import 'package:piggy_flutter/main.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(child: Center(child: Text("Chat Page"),),);
  }
}
