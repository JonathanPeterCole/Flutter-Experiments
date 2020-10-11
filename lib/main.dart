import 'package:flutter_experiments/app/app.dart';
import 'package:flutter_experiments/environment/environment.dart';

Future<void> main() async {
  // Set the environment config
  final Environment env = const Environment(
    environment: EnvironmentType.Prod,
    apiUrl: 'https://example.api.com/'
  );

  // Start the app
  init(env);
}