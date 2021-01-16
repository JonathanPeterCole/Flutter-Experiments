import 'package:flutter/foundation.dart';

/// Defines the environment settings for the application.
/// 
/// All environment settings are constants, so tree shaking will apply.
class Environment {
  /// Whether or not the app is running in debug mode.
  static const bool DEBUG = kDebugMode;
  /// The URL host that API requests should be made to.
  static const String API_URL = String.fromEnvironment(
    'API_URL',
    defaultValue: 'https://example.api.com/'
  );
  /// The optional target platform override.
  static const TargetPlatform PLATFORM_OVERRIDE = !bool.hasEnvironment('PLATFORM_OVERRIDE')
    ? null : String.fromEnvironment('PLATFORM_OVERRIDE') == 'android'
      ? TargetPlatform.android
      : TargetPlatform.iOS;

}