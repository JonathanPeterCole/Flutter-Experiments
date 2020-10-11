class Environment {
  /// Holds environment-specific config as set in the environment's main.dart file.
  const Environment({
    this.environment,
    this.apiUrl
  });

  /// The app environment enum (for env-specific code).
  final EnvironmentType environment;
  /// The placeholder API URL.
  final String apiUrl;
}

enum EnvironmentType {
  Prod, Local
}