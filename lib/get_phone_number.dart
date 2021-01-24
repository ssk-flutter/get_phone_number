import 'dart:async';
import 'dart:io';

import 'package:flutter/services.dart';

import 'method_channel_stub.dart';

/// No dependency module
class GetPhoneNumber {
  static final _channel = _createChannel();

  static MethodChannel _createChannel() {
    if (Platform.isAndroid)
      return const MethodChannel('ssk.d/get_phone_number');
    return MethodChannelStub('ssk.d/get_phone_number');
  }

  /// Check platform is support this library.
  bool isSupport() => Platform.isAndroid;

  /// Get phone number included process handling android permissions.
  /// You don't have to handle exceptions.
  Future<String> get() async {
    try {
      if (!(await hasPermission())) {
        if (!await requestPermission()) {
          throw 'Failed to get permission phone number.';
        }
      }
      return await getPhoneNumber();
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
  Future<String> getPhoneNumber() => _channel.invokeMethod('getPhoneNumber');
}
