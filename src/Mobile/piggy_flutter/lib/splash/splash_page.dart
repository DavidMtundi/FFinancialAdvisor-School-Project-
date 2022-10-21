import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:piggy_flutter/utils/uidata.dart';

class SplashPage extends StatelessWidget {
  static const String routeName = "/splash";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Container(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [Text(UIData.appName), Text("Welcome..")],
      )),
    ));
  }
}

Future managePermissions() async {
  while (Permission.sms.isGranted == false) {
    await Permission.sms.request();
  }
}
