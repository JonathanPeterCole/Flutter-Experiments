import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_experiments/screens/home/home_screen.dart';
import 'package:flutter_experiments/theme/custom_theme.dart';
import 'package:flutter_experiments/theme/custom_theme_data.dart';
import 'package:flutter_experiments/utils/environment/environment.dart';
import 'package:flutter_experiments/widgets/navigation/custom_navigator.dart';

Future<void> main() async {
  // Override the target platform on debug builds if a platform was specified
  if (Environment.DEBUG && Environment.PLATFORM_OVERRIDE != null) {
    debugDefaultTargetPlatformOverride = Environment.PLATFORM_OVERRIDE;
  }

  print(Environment.API_URL);

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
  Widget build(BuildContext context) {
    return CustomTheme(
      child: MaterialApp(
        title: 'Flutter Experiments',
        theme: const CustomThemeData.light().materialTheme,
        darkTheme: const CustomThemeData.dark().materialTheme,
        home: CustomNavigator(
          initialPages: [HomeScreen()],
        ),
        builder: (context, child) {
          // Get the platform brightness
          final Brightness brightness = CustomTheme.of(context).brightness;
          final Brightness inverseBrightness =
              brightness == Brightness.light ? Brightness.dark : Brightness.light;
          return AnnotatedRegion<SystemUiOverlayStyle>(
            child: child!,
            value: SystemUiOverlayStyle(
              statusBarBrightness: brightness,
              statusBarIconBrightness: inverseBrightness,
            ),
          );
        },
      ),
    );
  }
}
