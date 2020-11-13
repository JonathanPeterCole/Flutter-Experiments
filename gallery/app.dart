import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_experiments/models/environment/environment.dart';
import 'package:flutter_experiments/models/environment/environment_type.dart';
import 'package:flutter_experiments/theme/custom_theme.dart';
import 'package:flutter_experiments/theme/custom_theme_data.dart';
import 'package:get_it/get_it.dart';

import 'screens/home.dart';

Future<void> init() async {
  // Prepare GetIt service locator
  final getIt = GetIt.instance;
  getIt.registerSingleton<Environment>(const Environment(
    environment: EnvironmentType.Local
  ));

  // Set transparent status bar (the overlay style is also set when the app rebuilds, but using an
  // AppBar seems to override the status bar color unless it is also set here)
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
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
      builder: (context, child) {
        // Get the platform brightness
        final Brightness brightness = CustomTheme.of(context).brightness;
        final Brightness inverseBrightness = brightness == Brightness.light
            ? Brightness.dark
            : Brightness.light;
        return AnnotatedRegion<SystemUiOverlayStyle>(
          child: child,
          value: SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarBrightness: brightness,
            statusBarIconBrightness: inverseBrightness,
            systemNavigationBarColor: CustomTheme.of(context).surface,
            systemNavigationBarIconBrightness: inverseBrightness
          ),
        );
      },
      home: GalleryTabsPage(),
    ),
  );
}