import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'get_phone_number_platform_interface.dart';

/// An implementation of [GetPhoneNumberPlatform] that uses method channels.
class MethodChannelGetPhoneNumber extends GetPhoneNumberPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('get_phone_number');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
