import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_auth/screens/homepage.dart';
import 'package:flutter_auth/screens/login.dart';
import 'package:flutter_auth/screens/protected.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert' show json, base64, ascii;

final storage = FlutterSecureStorage();

void main() async {
  runApp(MyApp(storage));
}

class MyApp extends StatelessWidget {
  final FlutterSecureStorage storage;

  MyApp(this.storage);

  Future<String> get jwtOrEmpty async {
    String jwt = await storage.read(key: "jwt_token");
    if (jwt == null) return "";
    return jwt;
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      home: FutureBuilder(
          future: jwtOrEmpty,
          builder: (context, snapshot) {
            if (!snapshot.hasData) return CircularProgressIndicator();
            if (snapshot.data != "") {
              var str = snapshot.data;
              var jwt = str.split(".");

              if (jwt.length != 3) {
                return LoginScreen();
              } else {
                var payload = json.decode(
                    ascii.decode(base64.decode(base64.normalize(jwt[1]))));
                if (DateTime.fromMillisecondsSinceEpoch(payload["exp"] * 1000)
                    .isAfter(DateTime.now())) {
                  return ProtectedScreen(str, payload);
                } else {
                  return LoginScreen();
                }
              }
            } else {
              return HomeScreen();
            }
          }),
    );
  }
}
