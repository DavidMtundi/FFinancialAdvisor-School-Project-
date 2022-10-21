import 'dart:async';

import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:piggy_flutter/models/models.dart';
import 'package:piggy_flutter/repositories/piggy_api_client.dart';
import 'package:piggy_flutter/utils/common.dart';

import '../../theme/piggy_app_theme.dart';

class phone_transaction_screen extends StatefulWidget {
  const phone_transaction_screen({Key? key}) : super(key: key);

  @override
  State<phone_transaction_screen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<phone_transaction_screen> {
  List<TransactionModel> alltransactions = [];
  @override
  void initState() {
    super.initState();
  }

  Future<List<TransactionModel>> LoadSmsFromPhone() async {
    alltransactions = await PiggyApiClient().getFromSmsandAddToTransaction();
    return alltransactions;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: false,
          backgroundColor: Colors.white,
          title: Text(
            "Phone Transactions",
            style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87),
          ),
        ),
        body: FutureBuilder(
            future: LoadSmsFromPhone(),
            builder: ((context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasError) {
                  return Center(
                    child: Text("An Error Occured"),
                  );
                } else if (snapshot.hasData) {
                  final data = snapshot.data as List<TransactionModel>;

                  return data.isNotEmpty
                      ? SingleChildScrollView(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ...data
                                  .map((e) => buildTransactionList(context, e))
                            ],
                          ),
                        )
                      : Center(
                          child: Text("No New Phone Transactions"),
                        );
                } else {
                  return Text("No Transactions Found");
                }
              } else {
                return Center(
                  child: Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(
                          color: Colors.black,
                          strokeWidth: 10,
                          semanticsLabel: "Loading Messages",
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Text("Please Wait ..")
                      ],
                    ),
                  ),
                );
              }
            })),
      ),
    );
  }
}

MergeSemantics buildTransactionList(
    BuildContext context, TransactionModel transaction) {
  final TextTheme textTheme = Theme.of(context).textTheme;
  return MergeSemantics(
    child: ListTile(
      // tileColor: transaction.amount! > 0
      //     ? PiggyAppTheme.income
      //     : PiggyAppTheme.expense,
      dense: true,
      leading: Padding(
        padding: const EdgeInsets.all(6.0),
        child: NeumorphicIcon(
          IconData(Icons.account_balance_wallet_rounded.codePoint),
          size: 24,
          style: NeumorphicStyle(
            shape: NeumorphicShape.convex,
            surfaceIntensity: 1.0,
            color: transaction.amount! > 0
                ? PiggyAppTheme.income
                : PiggyAppTheme.expense,
          ),
        ),
      ),
      title: Text(
        transaction.categoryName != null ? transaction.categoryName! : "Food",
        style: textTheme.bodyText1,
      ),
      subtitle: Text(
        "${transaction.description}\n${transaction.creatorUserName}'s ${transaction.accountName}",
      ),
      isThreeLine: true,
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(
            '${transaction.amount!.toMoney()}Kshs',
          ),
          Text(
            '${transaction.balance.toMoney()}Kshs',
            style: TextStyle(
              color: PiggyAppTheme.nearlyBlue,
              fontSize: 12,
              fontWeight: FontWeight.w300,
            ),
          )
        ],
      ),
      onTap: () {},
    ),
  );
}
