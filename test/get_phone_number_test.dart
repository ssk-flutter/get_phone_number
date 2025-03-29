import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_phone_number/get_phone_number.dart';

void main() {
  const MethodChannel channel = MethodChannel('get_phone_number');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (MethodCall methodCall) async {
          return '42';
        });
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, null);
  });

  test('getWithPermission', () async {
    expect(await GetPhoneNumber().get(), '');
  });
}
