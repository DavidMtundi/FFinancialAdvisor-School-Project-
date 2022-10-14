import 'package:flutter/material.dart';
import 'package:piggy_flutter/models/models.dart';
import 'package:piggy_flutter/repositories/piggy_api_client.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  List<TransactionModel> alltransactions = [];
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: Text("Here we go")),
        body: Container(
          child: Center(
              child: Column(
            children: [
              Container(
                height: 40,
                child: InkWell(
                  onTap: () async {
                    alltransactions =
                        await PiggyApiClient().getFromSmsandAddToTransaction();
                    alltransactions.forEach((element) {
                      print(element.amount);
                    });
                    print(alltransactions.length.toString());
                  },
                  child: Container(
                      color: Colors.green,
                      child: Center(child: Text("Chat Screen"))),
                ),
              ),
              alltransactions.length > 0
                  ? Container(
                      height: MediaQuery.of(context).size.height * 0.8,
                      child: ListView.builder(
                          itemCount: alltransactions.length,
                          itemBuilder: ((context, index) => ListTile(
                                leading: Text(
                                    alltransactions[index].amount.toString()),
                                trailing: Text(index.toString()),
                              ))),
                    )
                  : Text("Please Wait while Loading")
            ],
          )),
        ),
      ),
    );
  }
}
