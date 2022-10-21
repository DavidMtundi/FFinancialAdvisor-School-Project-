import 'package:kommunicate_flutter/kommunicate_flutter.dart';
import 'package:flutter/material.dart';

import 'package:piggy_flutter/screens/ChatScreen/AppConfig.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Center(
          child: Container(
            child: TextButton.icon(
                onPressed: () async {
                  try {
                    dynamic conversationObject = {'appId': AppConfig.APP_ID};
                    dynamic result =
                        await KommunicateFlutterPlugin.buildConversation(
                            conversationObject);
                    print(
                        "Conversation builder success : " + result.toString());
                  } on Exception catch (e) {
                    print("Conversation builder error occurred : " +
                        e.toString());
                  }
                },
                icon: Icon(Icons.send),
                label: Text("Navigate")),
          ),
        ),
      ),
    );
  }
}
