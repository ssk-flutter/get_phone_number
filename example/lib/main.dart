import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get_phone_number/get_phone_number.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  var message = 'Please try to functions below.';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(child: Center(child: Text(message))),
            TextButton(
                child: Text('Check platform is support.'),
                onPressed: () => setState(() =>
                    message = 'support: ${GetPhoneNumber().isSupport()}')),
            TextButton(
                child: Text('Simple Function()'),
                onPressed: () => onSimpleFunction()),
            TextButton(
                child: Text('List of phone numbers()'),
                onPressed: () => onListOfPhoneNumbersFunction()),
            TextButton(
                child: Text('Detailed functions'),
                onPressed: () => onDetailedFunctions()),
            Padding(
              padding: const EdgeInsets.only(left: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextButton(
                      child: Text('-> Has Permission()'),
                      onPressed: () async {
                        final result = await GetPhoneNumber().hasPermission();
                        setState(() => message = 'has permission: $result');
                      }),
                  TextButton(
                      child: Text('-> Request Permission()'),
                      onPressed: () async {
                        final result =
                            await GetPhoneNumber().requestPermission();
                        setState(() => message = 'request permission: $result');
                      }),
                ],
              ),
            ),
            TextButton(
                child: Text('test'), onPressed: () => getSimCardList()),
          ],
        ),
      ),
    );
  }

  onSimpleFunction() async {
    setState(() => message = 'Trying... No need to handle exceptions.');

    final result = await GetPhoneNumber().get();
    setState(() => message = 'Your phone number is "$result"');
  }

  onListOfPhoneNumbersFunction() async {
    setState(() => message = 'Trying... No need to handle exceptions.');

    final list = await GetPhoneNumber().getListPhoneNumber();

    setState(() => message = 'List of phone number is "$list"');
  }

  onDetailedFunctions() async {
    setState(() => message = 'Trying... You will want to handle exceptions.');

    try {
      if (!await GetPhoneNumber().hasPermission()) {
        if (!await GetPhoneNumber().requestPermission()) {
          throw 'Failed to get permission phone number';
        }
      }

      String result = await GetPhoneNumber().getPhoneNumber();
      if (kDebugMode) {
        print('getPhoneNumber result: $result');
      }
      setState(() => message = 'Your phone number is "$result"');
    } catch (e) {
      setState(() => message = e.toString());
    }
  }

  getSimCardList() async {
    setState(() => message = 'Trying... No need to handle exceptions.');

    final result = await GetPhoneNumber().getSimCardList();

    setState(() => message = 'Your phone number is "${result.map((e) => e.number).join('\n')}"');
  }
}
