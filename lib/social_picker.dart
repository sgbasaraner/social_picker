import 'dart:async';

import 'package:flutter/services.dart';

class SocialPicker {
  static const MethodChannel _channel = const MethodChannel('social_picker');

  static Future<String> pickMedia({int maxVideoDurationSeconds}) async {
    final String version = await _channel.invokeMethod('pickMedia', maxVideoDurationSeconds);
    return version;
  }
}
