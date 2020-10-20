import 'package:flutter_experiments/models/environment/environment.dart';
import 'package:flutter_experiments/app.dart';
import 'package:flutter_experiments/models/environment/environment_type.dart';

Future<void> main() async {
  // Set the environment config
  final Environment env = const Environment(
    environment: EnvironmentType.Local,
    apiUrl: 'https://localhost:1000/'
  );

  // Start the app
  init(env);
}