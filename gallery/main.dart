import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_experiments/models/environment/environment.dart';
import 'package:flutter_experiments/models/environment/environment_type.dart';
import 'package:flutter_experiments/theme/custom-theme.dart';
import 'package:get_it/get_it.dart';

import 'gallery_tabs.dart';

Future<void> main() async {
  // Prepare GetIt service locator
  final getIt = GetIt.instance;
  getIt.registerSingleton<Environment>(const Environment(
    environment: EnvironmentType.Local
  ));

  // Start the app
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
    ));
    
    return MaterialApp(
      title: 'Flutter Experiments Gallery',
      theme: CustomTheme.themeLight.materialTheme,
      darkTheme: CustomTheme.themeDark.materialTheme,
      home: GalleryTabsPage(),
    );
  }
}