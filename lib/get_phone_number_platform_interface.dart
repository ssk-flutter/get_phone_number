import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'get_phone_number_method_channel.dart';

abstract class GetPhoneNumberPlatform extends PlatformInterface {
  /// Constructs a GetPhoneNumberPlatform.
  GetPhoneNumberPlatform() : super(token: _token);

  static final Object _token = Object();

  static GetPhoneNumberPlatform _instance = MethodChannelGetPhoneNumber();

  /// The default instance of [GetPhoneNumberPlatform] to use.
  ///
  /// Defaults to [MethodChannelGetPhoneNumber].
  static GetPhoneNumberPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [GetPhoneNumberPlatform] when
  /// they register themselves.
  static set instance(GetPhoneNumberPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
