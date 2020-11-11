import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_experiments/models/environment/environment.dart';
import 'package:flutter_experiments/models/environment/environment_type.dart';
import 'package:flutter_experiments/theme/custom_theme.dart';
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

  debugDefaultTargetPlatformOverride = TargetPlatform.iOS;

  // Start the app
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'Flutter Experiments Gallery',
    theme: CustomTheme.themeLight.materialTheme,
    darkTheme: CustomTheme.themeDark.materialTheme,
    builder: (context, child) {
      // Get the platform brightness
      final Brightness platformBrightness = MediaQuery.platformBrightnessOf(context);
      final Brightness inverseBrightness = platformBrightness == Brightness.light
          ? Brightness.dark
          : Brightness.light;
      // Set the overlay styles
      return AnnotatedRegion<SystemUiOverlayStyle>(
        child: child,
        value: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarBrightness: platformBrightness,
          statusBarIconBrightness: inverseBrightness,
          systemNavigationBarColor: CustomTheme.brightness(platformBrightness).surface,
          systemNavigationBarIconBrightness: inverseBrightness
        ),
      );
    },
    home: GalleryTabsPage(),
  );
}