import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:get_phone_number/get_phone_number.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  var message = 'Your phone number is unknown. (Please try to functions below)';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(child: Center(child: Text(message))),
            RaisedButton(
                child: Text('Simple Function()'),
                onPressed: () => onSimpleFunction()),
            RaisedButton(
                child: Text('Detailed functions'),
                onPressed: () => onDetailedFunctions()),
          ],
        ),
      ),
    );
  }

  onSimpleFunction() async {
    setState(() => message = 'Trying... No need to handle exceptions.');

    final result = await GetPhoneNumber().getWithPermission();
    setState(() => message = result);
  }

  onDetailedFunctions() async {
    setState(() => message = 'Trying... You will want to handle exceptions.');

    try {
      if (!await GetPhoneNumber().hasPermission()) {
        if (!await GetPhoneNumber().requestPermission()) {
          throw 'Failed to get permission phone number';
        }
      }

      String result = await GetPhoneNumber().get();
      print('getPhoneNumber result: $result');
      setState(() => message = result);
    } catch (e) {
      setState(() => message = e.toString());
    }
  }
}
