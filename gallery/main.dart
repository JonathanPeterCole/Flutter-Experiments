import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_experiments/theme/custom_theme.dart';
import 'package:flutter_experiments/theme/custom_theme_data.dart';
import 'package:flutter_experiments/utils/environment/environment.dart';
import 'package:flutter_experiments/widgets/navigation/custom_navigator.dart';

import 'screens/home/home.dart';

Future<void> main() async {
  // Override the target platform on debug builds if a platform was specified
  if (Environment.DEBUG && Environment.PLATFORM_OVERRIDE != null) {
    debugDefaultTargetPlatformOverride = Environment.PLATFORM_OVERRIDE;
  }

  // Set transparent status bar (the overlay style is also set when the app rebuilds, but using an
  // AppBar seems to override the status bar color unless it is also set here)
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
  ));

  // Start the app
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) => CustomTheme(
        child: MaterialApp(
          title: 'Flutter Experiments Gallery',
          theme: const CustomThemeData.light().materialTheme,
          darkTheme: const CustomThemeData.dark().materialTheme,
          home: CustomNavigator(
            initialPages: [GalleryTabsPage()],
          ),
          builder: (context, child) {
            // Get the platform brightness
            final Brightness brightness = CustomTheme.of(context).brightness;
            final Brightness inverseBrightness =
                brightness == Brightness.light ? Brightness.dark : Brightness.light;
            return AnnotatedRegion<SystemUiOverlayStyle>(
              child: child!,
              value: SystemUiOverlayStyle(
                statusBarColor: Colors.transparent,
                statusBarBrightness: brightness,
                statusBarIconBrightness: inverseBrightness,
              ),
            );
          },
        ),
      );
}
