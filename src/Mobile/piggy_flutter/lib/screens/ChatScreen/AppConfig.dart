class AppConfig {
  static const APP_ID = '1dd1e6b3f66cb0b5c52fb7773da27eb49';

  static bool isValidEmail(String emailId) {
    return RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(emailId);
  }
}
