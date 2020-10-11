import 'package:flutter_experiments/environment/environment.dart';
import 'package:flutter_experiments/app/app.dart';

Future<void> main() async {
  // Set the environment config
  final Environment env = const Environment(
    environment: EnvironmentType.Local,
    apiUrl: 'https://localhost:1000/'
  );

  // Start the app
  init(env);
}