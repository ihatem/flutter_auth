import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'dart:convert' show json, base64, ascii;

import 'package:flutter_auth/main.dart';
import 'package:flutter_auth/screens/homepage.dart';

class ProtectedScreen extends StatelessWidget {
  ProtectedScreen(this.jwt, this.payload);

  factory ProtectedScreen.fromBase64(String jwt) => ProtectedScreen(
      jwt,
      json.decode(
          ascii.decode(base64.decode(base64.normalize(jwt.split(".")[1])))));

  final String jwt;
  final Map<String, dynamic> payload;

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text("Protected route"),
      ),
      child: SafeArea(
          child: Center(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
            Text("Secret Route"),
            CupertinoButton(
                child: Text("Sign out"),
                onPressed: () async {
                  await storage.deleteAll();
                  Navigator.pushAndRemoveUntil(
                      context,
                      CupertinoPageRoute(
                          builder: (BuildContext context) => HomeScreen()),
                      (_) => false);
                })
          ]))),
    );
  }
}
