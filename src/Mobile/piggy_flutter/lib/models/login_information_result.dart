import 'package:piggy_flutter/models/models.dart';

class LoginInformationResult {
  LoginInformationResult({this.user, this.tenant});

  final UserModel? user;
  final Tenant? tenant;
}
