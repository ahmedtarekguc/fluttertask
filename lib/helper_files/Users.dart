class Users {
  final int? id;
  final String userName;
  final String password;
  final String interest;

  Users(this.id, this.userName, this.password, this.interest);

  Users.fromMap(Map<String, dynamic> res)
      : id = res["id"],
        userName = res["userName"],
        password = res["password"],
        interest = res["interest"];

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'userName': userName,
      'password': password,
      'interest': interest,
    };
  }
}
