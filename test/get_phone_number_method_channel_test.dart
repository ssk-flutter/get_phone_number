import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_phone_number/get_phone_number_method_channel.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  MethodChannelGetPhoneNumber platform = MethodChannelGetPhoneNumber();
  const MethodChannel channel = MethodChannel('get_phone_number');

  setUp(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(
      channel,
      (MethodCall methodCall) async {
        return '42';
      },
    );
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(channel, null);
  });

  test('getPlatformVersion', () async {
    expect(await platform.getPlatformVersion(), '42');
  });
}
