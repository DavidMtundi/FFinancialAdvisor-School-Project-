class AuthenticateResult {
  final String? accessToken, encryptedAccessToken,userId;
  final int? expireInSeconds;

  AuthenticateResult(
      {this.accessToken,
      this.encryptedAccessToken,
      this.expireInSeconds,
      this.userId});

  AuthenticateResult.fromJson(Map<String, dynamic> json)
      : accessToken = json['accessToken'],
        encryptedAccessToken = json['encryptedAccessToken'],
        expireInSeconds = json['expireInSeconds'],
        userId = json['userId'];
}
