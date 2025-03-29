import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

class MethodChannelStub extends MethodChannel {
  MethodChannelStub(super.name);

  @override
  @optionalTypeArgs
  Future<T> invokeMethod<T>(String method, [dynamic arguments]) {
    switch (method) {
      case 'hasPermission':
      case 'requestPermission':
        return Future<bool>.value(true) as Future<T>;
      case 'getPhoneNumber':
        return Future<String>.value('') as Future<T>;
      case 'getSimCardList':
        return Future<String>.value('[]') as Future<T>;
      default:
        throw 'Unhandled stub method';
    }
  }
}
