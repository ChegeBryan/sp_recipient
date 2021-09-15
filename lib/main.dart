import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sp_recipient/models/user.dart';
import 'package:sp_recipient/services/auth.dart';
import 'package:sp_recipient/services/donors.dart';
import 'package:sp_recipient/services/user.dart';
import 'package:sp_recipient/util/shared_preferences.dart';
import 'package:sp_recipient/views/auth/screens/login.dart';
import 'package:sp_recipient/views/auth/screens/register.dart';
import 'package:sp_recipient/views/screens/donors_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthProvider()),
        ChangeNotifierProvider(create: (context) => UserProvider()),
        ChangeNotifierProvider(create: (context) => DonorProvider()),
      ],
      child: MaterialApp(
        title: 'SP Recipient',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: FutureBuilder<User>(
          future: UserPrefences().getUser(),
          builder: (context, AsyncSnapshot<User> snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.data!.email == null) {
                return LoginScreen();
              }
              Provider.of<UserProvider>(context).setUser(snapshot.data);
              return DonorScreen();
            }
            return Center(
              child: CircularProgressIndicator(),
            );
          },
        ),
        routes: {
          '/login': (context) => LoginScreen(),
          '/register': (context) => RegisterScreen(),
          '/donors': (context) => DonorScreen(),
        },
      ),
    );
  }
}
