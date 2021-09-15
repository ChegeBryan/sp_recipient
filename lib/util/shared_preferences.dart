import 'package:shared_preferences/shared_preferences.dart';
import 'package:sp_recipient/models/user.dart';

class UserPrefences {
  Future<void> saveUser(User user) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.setString('email', user.email!);
    prefs.setString('userRole', user.role!);
    prefs.setInt('userId', user.id!);
  }

  Future<User> getUser() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    String? email = prefs.getString('email');
    String? userRole = prefs.getString('userRole');
    int? userId = prefs.getInt('userId');

    return User(email: email, role: userRole, id: userId);
  }

  Future<void> removeUser() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.remove("email");
    prefs.remove('userRole');
    prefs.remove('userId');
  }
}
