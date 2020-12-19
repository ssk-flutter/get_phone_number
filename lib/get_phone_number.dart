import 'dart:async';

import 'package:flutter/services.dart';

/// No dependency module
class GetPhoneNumber {
  static const MethodChannel _channel =
      const MethodChannel('ssk.d/get_phone_number');

  /// Get phone number with handle android permissions.
  /// You don't have to handle exceptions.
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

  /// Check any permission granted to get the phone number.
  Future<bool> hasPermission() => _channel.invokeMethod('hasPermission');

  /// Request permission to get the phone number.
  Future<bool> requestPermission() =>
      _channel.invokeMethod('requestPermission');

  /// Get the phone number.
  /// You may handle exceptions to avoid error message.
  Future<String> get() => _channel.invokeMethod('getPhoneNumber');
}
