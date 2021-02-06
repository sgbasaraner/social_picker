import 'dart:async';

import 'package:flutter/services.dart';

class SocialPicker {
  static const MethodChannel _channel = const MethodChannel('social_picker');

  static Future<String> pickMedia() async {
    final String version = await _channel.invokeMethod('pickMedia', <String, dynamic>{
      "maxVideoDurationSeconds": 20,
    });
    return version;
  }
}
