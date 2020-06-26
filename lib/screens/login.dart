import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_auth/main.dart' show storage;
import 'package:flutter_auth/screens/protected.dart';
import 'package:flutter_auth/widgets/dialog.dart';

import 'package:http/http.dart' as http;
import 'dart:convert' show jsonDecode;

const SERVER_IP = "http://localhost:1337";

class LoginScreen extends StatefulWidget {
  LoginScreen({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  Future<String> attemptLogIn(String username, String password) async {
    var res = await http.post("$SERVER_IP/auth/local",
        body: {"identifier": username, "password": password});
    Map<String, dynamic> map = jsonDecode(res.body);
    if (res.statusCode == 200) return map["jwt"];
    return null;
  }

  TextEditingController _emailController;
  TextEditingController _passwordController;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController(text: '');
    _passwordController = TextEditingController(text: '');
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text("Login"),
      ),
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(bottom: 10.0),
                child: Text("Email",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontSize: 20.0,
                      color: Colors.blue,
                      decoration: TextDecoration.none,
                      fontWeight: FontWeight.normal,
                    )),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 30.0),
                child: CupertinoTextField(
                    controller: _emailController, placeholder: "Email "),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 10.0),
                child: Text("Password",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontSize: 20.0,
                      color: Colors.blue,
                      decoration: TextDecoration.none,
                      fontWeight: FontWeight.normal,
                    )),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 30.0),
                child: CupertinoTextField(
                    obscureText: true,
                    controller: _passwordController,
                    placeholder: "Password "),
              ),
              CupertinoButton.filled(
                child: Text("Login"),
                onPressed: () async {
                  var username = _emailController.text;
                  var password = _passwordController.text;
                  var jwt = await attemptLogIn(username, password);
                  if (jwt != null) {
                    await storage.write(key: "jwt_token", value: jwt);
                    Navigator.pushAndRemoveUntil(
                        context,
                        CupertinoPageRoute(
                            builder: (BuildContext context) =>
                                ProtectedScreen.fromBase64(jwt)),
                        (_) => false);
                  } else {
                    displayDialog(context, "An Error Occurred",
                        "No account was found matching that username and password");
                  }
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
