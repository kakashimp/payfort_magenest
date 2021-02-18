import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:payfort_magenest/payfort_magenest.dart';

void main() {
  const MethodChannel channel = MethodChannel('payfort_magenest');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('getPlatformVersion', () async {
    expect(await PayfortMagenest.platformVersion, '42');
  });
}
