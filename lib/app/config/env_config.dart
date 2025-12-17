class Env {
  static const String PROD = 'prod';
  static const String QAS = 'QAS';
  static const String DEV = 'dev';
  static const String LOCAL = 'local';
}

class EnvConfig {
  // Change this value to switch between different environments.
  static const String _currentEnvironment = Env.LOCAL;

  // List of available environments and their specific configurations.
  static final List<Map<String, String>> _availableEnvironments = [
    {
      'env': Env.LOCAL,
      'url': 'http://localhost:8080/api/',
    },
    {
      'env': Env.DEV,
      'url': 'https://dev.yourapi.com/api/', // TODO: Add your DEV URL
    },
    {
      'env': Env.QAS,
      'url': 'https://qas.yourapi.com/api/', // TODO: Add your QAS URL
    },
    {
      'env': Env.PROD,
      'url': 'https://api.yourapi.com/api/', // TODO: Add your PROD URL
    },
  ];

  /// Returns the configuration for the current environment.
  static Map<String, String> get environment {
    return _availableEnvironments.firstWhere(
      (d) => d['env'] == _currentEnvironment,
    );
  }

  /// Returns the API base URL for the current environment.
  static String get apiUrl {
    return environment['url'] ?? '';
  }
}
