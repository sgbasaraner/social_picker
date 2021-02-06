import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:social_picker/social_picker.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _mediaPath = 'Unknown';

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> pickMedia() async {
    String path;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      path = await SocialPicker.pickMedia();
    } on PlatformException {
      path = 'Failed to pick media.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _mediaPath = path;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text(_mediaPath),
        ),
        body: Center(
          child: FlatButton(
            onPressed: () {
              pickMedia();
            },
            child: Text('pick media'),
          ),
        ),
      ),
    );
  }
}
