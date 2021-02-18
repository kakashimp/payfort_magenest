
import 'dart:async';

import 'package:flutter/services.dart';

class PayfortMagenest {
  static const MethodChannel _channel =
      const MethodChannel('payfort_magenest');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }
}
