import 'dart:async';

import 'package:flutter/services.dart';

class GetPhoneNumber {
  static const MethodChannel _channel =
      const MethodChannel('ssk.d/get_phone_number');

  Future<String> getWithPermission() async {
    try {
      if (!(await hasPermission())) {
        if (!await requestPermission()) {
          throw 'Failed to get permission phone number.';
        }
      }
      return await get();
    } catch (e) {
      return "";
    }
  }

  Future<bool> hasPermission() => _channel.invokeMethod('hasPermission');

  Future<bool> requestPermission() =>
      _channel.invokeMethod('requestPermission');

  Future<String> get() => _channel.invokeMethod('getPhoneNumber');
}
