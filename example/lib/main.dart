import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get_phone_number/get_phone_number.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  var message = 'Please try to functions below.';

  final MobileScannerController controller = MobileScannerController(
    // required options for the scanner
  );

  StreamSubscription<Object?>? _subscription;

  @override
  void initState() {
    super.initState();
    // Start listening to lifecycle changes.
    WidgetsBinding.instance.addObserver(this);

    // Start listening to the barcode events.
    _subscription = controller.barcodes.listen(_handleBarcode);

    // Finally, start the scanner itself.
    unawaited(controller.start());
  }

  @override
  Future<void> dispose() async {
    // Stop listening to lifecycle changes.
    WidgetsBinding.instance.removeObserver(this);
    // Stop listening to the barcode events.
    unawaited(_subscription?.cancel());
    _subscription = null;
    // Dispose the widget itself.
    super.dispose();
    // Finally, dispose of the controller.
    await controller.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // If the controller is not ready, do not try to start or stop it.
    // Permission dialogs can trigger lifecycle changes before the controller is ready.
    if (!controller.value.hasCameraPermission) {
      return;
    }

    switch (state) {
      case AppLifecycleState.detached:
      case AppLifecycleState.hidden:
      case AppLifecycleState.paused:
        return;
      case AppLifecycleState.resumed:
      // Restart the scanner when the app is resumed.
      // Don't forget to resume listening to the barcode events.
        _subscription = controller.barcodes.listen(_handleBarcode);

        unawaited(controller.start());
      case AppLifecycleState.inactive:
      // Stop the scanner when the app is paused.
      // Also stop the barcode events subscription.
        unawaited(_subscription?.cancel());
        _subscription = null;
        unawaited(controller.stop());
    }
  }



  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(flex: 9, child: MobileScanner(
              controller: controller, onDetect: _handleBarcode,
            ),),
            Expanded(flex: 1, child: Center(child: Text(message))),

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
      print('getPhoneNumber result: $result');
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

  void _handleBarcode(BarcodeCapture event) {
    print('barcode: ${event.barcodes.map((e)=>e.displayValue).join(',')}');
    setState(() {
      message = 'barcode: ${event.barcodes.map((e)=>e.displayValue).join(',')}';
    });
  }
}
