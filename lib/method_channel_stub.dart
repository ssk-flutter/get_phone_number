import 'package:flutter/foundation.dart';

class MethodChannelStub {
  @optionalTypeArgs
  Future<T> invokeMethod<T>(String method, [dynamic arguments]) {
    switch (method) {
      case 'hasPermission':
      case 'requestPermission':
        return Future<bool>.value(true) as Future<T>;
      case 'getPhoneNumber':
        return Future<String>.value('') as Future<T>;
      default:
        throw 'Unhandled stub method';
    }
  }
}
