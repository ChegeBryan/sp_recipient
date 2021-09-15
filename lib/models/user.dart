class User {
  String? email;
  String? role;
  int? id;

  User({this.email, this.role, this.id});

  factory User.fromJson(Map<String, dynamic> responseData) {
    return User(
      email: responseData['email'],
      role: responseData['role'],
      id: responseData['user_id'],
    );
  }
}
