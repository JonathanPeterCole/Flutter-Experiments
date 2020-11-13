import 'package:flutter/foundation.dart';

import 'app.dart';

Future<void> main() async {
  // Override the target platform
  const String targetPlatform = String.fromEnvironment('TARGET_PLATFORM');
  if (targetPlatform == 'IOS') {
    debugDefaultTargetPlatformOverride = TargetPlatform.iOS;
  } else if (targetPlatform == 'ANDROID') {
    debugDefaultTargetPlatformOverride = TargetPlatform.android;
  }
  
  // Start the app
  init();
}