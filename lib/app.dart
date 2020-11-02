import 'package:flutter/services.dart';
import 'package:flutter_experiments/models/environment/environment.dart';
import 'package:flutter/material.dart';
import 'package:flutter_experiments/screens/home_screen.dart';
import 'package:flutter_experiments/theme/custom_theme.dart';
import 'package:get_it/get_it.dart';

Future<void> init(Environment env) async {
  // Prepare GetIt service locator
  final getIt = GetIt.instance;
  getIt.registerSingleton<Environment>(env);

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
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Experiments',
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
      home: HomeScreen(title: 'Flutter Experiments'),
    );
  }
}
