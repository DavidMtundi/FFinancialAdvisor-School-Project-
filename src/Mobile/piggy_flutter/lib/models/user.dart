class UserModel {
  UserModel(
      {this.id,
      this.name,
      this.surname,
      this.userName,
      this.emailAddress,
      this.profilePictureId});

  UserModel.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        surname = json['surname'],
        userName = json['userName'],
        emailAddress = json['emailAddress'],
        profilePictureId = json['profilePictureId'];

  final String? name, surname, userName, emailAddress, profilePictureId;
  final String? id;
}
