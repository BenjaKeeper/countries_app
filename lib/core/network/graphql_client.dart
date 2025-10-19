import 'package:injectable/injectable.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import '../config/environment.dart';

@module
abstract class GraphQLModule {
  @lazySingleton
  GraphQLClient get graphQLClient {
    final httpLink = HttpLink(
      EnvConfig.graphqlEndpoint,
      defaultHeaders: {
        'Content-Type': 'application/json',
      },
    );

    // Configure policies for better caching
    final policies = Policies(
      fetch: FetchPolicy.cacheFirst,
    );

    return GraphQLClient(
      link: httpLink,
      cache: GraphQLCache(
        store: InMemoryStore(),
      ),
      defaultPolicies: DefaultPolicies(
        query: policies,
        mutate: Policies(
          fetch: FetchPolicy.networkOnly,
        ),
      ),
    );
  }
}
