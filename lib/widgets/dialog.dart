import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void displayDialog(context, title, text) => showDialog(
      context: context,
      builder: (context) =>
          CupertinoAlertDialog(title: Text(title), content: Text(text)),
    );
