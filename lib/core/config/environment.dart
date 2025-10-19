/// Environment configuration for the application
class EnvConfig {
  /// Get GraphQL endpoint
  /// Can be overridden with --dart-define=GRAPHQL_ENDPOINT=url
  static String get graphqlEndpoint {
    return const String.fromEnvironment(
      'GRAPHQL_ENDPOINT',
      defaultValue: 'https://countries.trevorblades.com/graphql',
    );
  }
}
