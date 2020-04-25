import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';

import 'app.dart';
// import 'firebase_ml_vision/example.dart';
// import 'barcode_scanner/example.dart';

Future<void> main() async {
  // Set `enableInDevMode` to true to see reports while in debug mode
  // This is only to be used for confirming that reports are being
  // submitted as expected. It is not intended to be used for everyday
  // development.
  Crashlytics.instance.enableInDevMode = true;

  // Pass all uncaught errors from the framework to Crashlytics.
  FlutterError.onError = Crashlytics.instance.recordFlutterError;

  runZoned(() {
      // Fetch the available cameras before initializing the app.
    runApp(MyApp());
  }, onError: Crashlytics.instance.recordError);
}
