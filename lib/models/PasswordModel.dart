class PasswordModel {
  String website;
  String username;
  String password;

  DateTime lastModified;
  DateTime created;

  PasswordModel({this.website, this.username, this.password, this.created});
  PasswordModel.withLastModified(
      {this.website,
      this.username,
      this.password,
      this.created,
      this.lastModified});

  Map<String, dynamic> toMap() {
    return {
      'website': website,
      'username': username,
      'password': password,
      'lastModified': lastModified?.toIso8601String(),
      'created': created?.toIso8601String(),
    };
  }
}
