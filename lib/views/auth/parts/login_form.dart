import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:sp_recipient/services/auth.dart';
import 'package:sp_recipient/services/user.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({Key? key}) : super(key: key);

  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  Map<String, dynamic> errors = {};

  final _formKey = GlobalKey<FormState>();

  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    AuthProvider auth = Provider.of<AuthProvider>(context);

    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            controller: _email,
            decoration: InputDecoration(
              labelText: 'Email',
              prefixIcon: Icon(Icons.email_outlined),
              border: OutlineInputBorder(),
            ),
            validator: (value) {
              if (value!.isEmpty) {
                return 'Please enter email.';
              }
              return null;
            },
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
          ),
          TextFormField(
            controller: _password,
            decoration: InputDecoration(
              labelText: 'Password',
              prefixIcon: Icon(Icons.lock_outlined),
              border: OutlineInputBorder(),
            ),
            obscureText: true,
            validator: (value) {
              if (value!.isEmpty) {
                return 'Please enter password';
              }
              return null;
            },
          ),
          Padding(padding: const EdgeInsets.symmetric(vertical: 8.0)),
          Container(
            width: MediaQuery.of(context).size.width,
            child: ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();

                  final Future<Map<String, dynamic>> userLogin =
                      auth.login(_email.text, _password.text);

                  userLogin.then((response) {
                    if (response['status']) {
                      if (response['user'].id != 2) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('User not authorized on this app.'),
                            duration: const Duration(seconds: 2),
                            backgroundColor: Colors.redAccent,
                          ),
                        );
                      } else {
                        Provider.of<UserProvider>(context, listen: false)
                            .setUser(response['user']);
                        Navigator.pushReplacementNamed(context, '/donors');
                      }
                    } else {
                      Map<String, dynamic> responseErrors = {};
                      var errorFields = response['message']['data'].keys;

                      for (var errorField in errorFields) {
                        responseErrors.putIfAbsent(errorField,
                            () => response['message']['data'][errorField]);
                      }
                      setState(() {
                        errors = responseErrors;
                      });
                    }
                  });
                }
              },
              child: Text(
                'Login',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
