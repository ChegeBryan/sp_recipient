import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sp_recipient/services/auth.dart';
import 'package:sp_recipient/services/user.dart';

import 'package:validators/validators.dart';

class RegisterForm extends StatefulWidget {
  const RegisterForm({Key? key}) : super(key: key);

  @override
  _RegisterFormState createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  Map<String, dynamic> errors = {};

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final TextEditingController _confirmPassword = TextEditingController();

  @override
  Widget build(BuildContext context) {
    AuthProvider auth = Provider.of<AuthProvider>(context);

    return Form(
      key: _formKey,
      child: Column(
        children: [
          Column(
            children: [
              TextFormField(
                controller: _email,
                keyboardType: TextInputType.emailAddress,
                autocorrect: false,
                decoration: InputDecoration(
                  labelText: 'Email',
                  prefixIcon: Icon(Icons.email_outlined),
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.fromLTRB(48, 8, 8, 8),
                ),
                textAlignVertical: TextAlignVertical.center,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter email';
                  } else if (!isEmail(value)) {
                    return 'Provide a valid email';
                  } else if (errors.containsKey('email_error')) {
                    return errors['email_error'];
                  }
                  return null;
                },
                onChanged: (value) {
                  errors.remove('email_error');
                },
              ),
              Padding(padding: const EdgeInsets.all(8.0)),
              TextFormField(
                controller: _password,
                autocorrect: false,
                decoration: InputDecoration(
                  labelText: 'Password',
                  prefixIcon: Icon(Icons.lock_outlined),
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.fromLTRB(48, 8, 8, 8),
                ),
                obscureText: true,
                textAlignVertical: TextAlignVertical.center,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please provide a password';
                  } else if (value.length < 8) {
                    return 'Password cannot be less than 8 Characters';
                  } else if (errors.containsKey('password_error')) {
                    return errors['password_error'];
                  }
                  return null;
                },
                onChanged: (value) {
                  errors.remove('password_error');
                },
              ),
              Padding(padding: const EdgeInsets.all(8.0)),
              TextFormField(
                controller: _confirmPassword,
                autocorrect: false,
                decoration: InputDecoration(
                  labelText: 'Confirm Password',
                  prefixIcon: Icon(Icons.lock_outlined),
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.fromLTRB(48, 8, 8, 8),
                ),
                obscureText: true,
                textAlignVertical: TextAlignVertical.center,
                validator: (value) {
                  if (value != _password.text) {
                    return 'Password does not match';
                  }
                  return null;
                },
              ),
              Padding(padding: const EdgeInsets.all(8.0)),
              Container(
                width: MediaQuery.of(context).size.width,
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();

                      final Future<Map<String, dynamic>> successMessage =
                          auth.register(_email.text, _password.text);

                      successMessage.then((response) {
                        if (response['status']) {
                          Provider.of<UserProvider>(context, listen: false)
                              .setUser(response['user']);
                          Navigator.pushReplacementNamed(context, '/donors');
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
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      SizedBox(),
                      Text(
                        'Register',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      Icon(
                        Icons.arrow_forward,
                        size: 18,
                        color: Colors.white,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
