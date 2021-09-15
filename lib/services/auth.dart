import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart';
import 'package:sp_recipient/models/user.dart';
import 'package:sp_recipient/services/backend.dart';
import 'package:sp_recipient/util/shared_preferences.dart';

enum Status { LoggedIn, NotLoggedIn, Authenticating }

class AuthProvider with ChangeNotifier {
  // track authentication status
  Status _loggedInStatus = Status.NotLoggedIn;

  Status get loggedInStatus => _loggedInStatus;

  Future<Map<String, dynamic>> login(String email, String password) async {
    var result;

    final Map<String, dynamic> data = {
      'email': email,
      'password': password,
    };

    _loggedInStatus = Status.Authenticating;
    notifyListeners();

    Response res = await post(
      Uri.parse(BackendUrl.login),
      body: data,
    );

    final Map<String, dynamic> responseData = jsonDecode(res.body);

    print(responseData);

    if (!responseData['error']) {
      User authUser = User.fromJson(responseData['data']);

      // persist user on app.
      UserPrefences().saveUser(authUser);

      _loggedInStatus = Status.LoggedIn;
      notifyListeners();

      result = {'status': true, 'message': 'Successful', 'user': authUser};
    } else {
      result = {'status': false, 'message': responseData};
    }

    return result;
  }

  Future<Map<String, dynamic>> register(String email, String password) async {
    var result;

    final Map<String, dynamic> data = {
      'email': email,
      'password': password,
      'role': '2'
    };

    Response res = await post(
      Uri.parse(BackendUrl.register),
      body: data,
    );

    final Map<String, dynamic> responseData = jsonDecode(res.body);

    if (!responseData['error']) {
      User authUser = User.fromJson(responseData['data']);

      // persist user on app.
      UserPrefences().saveUser(authUser);

      _loggedInStatus = Status.LoggedIn;
      notifyListeners();

      result = {'status': true, 'message': 'Successful', 'user': authUser};
    } else {
      _loggedInStatus = Status.LoggedIn;
      notifyListeners();
      result = {'status': false, 'message': responseData};
    }

    return result;
  }
}
