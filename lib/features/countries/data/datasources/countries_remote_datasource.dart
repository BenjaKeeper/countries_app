import 'dart:async';
import 'dart:io';

import 'package:countries_app/core/error/exceptions.dart' as app_exceptions;
import 'package:countries_app/core/logging/app_logger.dart';
import 'package:countries_app/features/countries/data/models/country_model.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class CountriesRemoteDataSource {
  final GraphQLClient client;

  CountriesRemoteDataSource(this.client);

  static const String _getAllCountriesQuery = '''
    query GetCountries {
      countries {
        code
        name
        emoji
        capital
        currency
        phone
        continent {
          code
          name
        }
        languages {
          code
          name
        }
      }
    }
  ''';

  static const String _getCountryByCodeQuery = '''
    query GetCountry(\$code: ID!) {
      country(code: \$code) {
        code
        name
        emoji
        capital
        currency
        phone
        continent {
          code
          name
        }
        languages {
          code
          name
        }
      }
    }
  ''';

  Future<List<CountryModel>> getAllCountries() async {
    appLogger.d('Fetching all countries from GraphQL API');

    try {
      final result = await client
          .query(
            QueryOptions(
              document: gql(_getAllCountriesQuery),
              fetchPolicy: FetchPolicy.cacheFirst,
            ),
          )
          .timeout(
            const Duration(seconds: 30),
            onTimeout: () {
              appLogger.e('Request timeout while fetching countries');
              throw TimeoutException('Request timeout');
            },
          );

      if (result.hasException) {
        final exception = result.exception!;
        appLogger.e('GraphQL exception: ${exception.toString()}');

        // Handle specific exception types
        if (exception.linkException != null) {
          final linkException = exception.linkException!;

          if (linkException is NetworkException ||
              linkException is HttpLinkServerException) {
            throw app_exceptions.NetworkException();
          }

          if (linkException is ServerException) {
            throw app_exceptions.ServerException(
              linkException.originalException.toString(),
            );
          }
        }

        throw app_exceptions.ServerException(exception.toString());
      }

      final List data = result.data?['countries'] ?? [];
      appLogger.i('Successfully fetched ${data.length} countries');

      return data
          .map((json) => CountryModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } on SocketException catch (e) {
      appLogger.e('Network error: No internet connection', error: e);
      throw app_exceptions.NetworkException();
    } on TimeoutException catch (e) {
      appLogger.e('Request timeout', error: e);
      throw app_exceptions.NetworkException();
    } on FormatException catch (e) {
      appLogger.e('Invalid data format', error: e);
      throw app_exceptions.ServerException('Invalid data format');
    } on app_exceptions.ServerException {
      rethrow;
    } on app_exceptions.NetworkException {
      rethrow;
    } catch (e, stackTrace) {
      appLogger.e(
        'Unknown error fetching countries',
        error: e,
        stackTrace: stackTrace,
      );
      throw app_exceptions.ServerException(e.toString());
    }
  }

  Future<CountryModel> getCountryByCode(String code) async {
    appLogger.d('Fetching country with code: $code');

    try {
      final result = await client
          .query(
            QueryOptions(
              document: gql(_getCountryByCodeQuery),
              variables: {'code': code},
              fetchPolicy: FetchPolicy.cacheFirst,
            ),
          )
          .timeout(
            const Duration(seconds: 30),
            onTimeout: () {
              appLogger.e('Request timeout while fetching country $code');
              throw TimeoutException('Request timeout');
            },
          );

      if (result.hasException) {
        final exception = result.exception!;
        appLogger.e(
          'GraphQL exception for country $code: ${exception.toString()}',
        );

        // Handle specific exception types
        if (exception.linkException != null) {
          final linkException = exception.linkException!;

          if (linkException is NetworkException ||
              linkException is HttpLinkServerException) {
            throw app_exceptions.NetworkException();
          }

          if (linkException is ServerException) {
            throw app_exceptions.ServerException(
              linkException.originalException.toString(),
            );
          }
        }

        throw app_exceptions.ServerException(exception.toString());
      }

      final data = result.data?['country'];
      if (data == null) {
        appLogger.w('Country not found: $code');
        throw app_exceptions.ServerException('Country not found');
      }

      appLogger.i('Successfully fetched country: $code');
      return CountryModel.fromJson(data as Map<String, dynamic>);
    } on SocketException catch (e) {
      appLogger.e('Network error: No internet connection', error: e);
      throw app_exceptions.NetworkException();
    } on TimeoutException catch (e) {
      appLogger.e('Request timeout for country $code', error: e);
      throw app_exceptions.NetworkException();
    } on FormatException catch (e) {
      appLogger.e('Invalid data format for country $code', error: e);
      throw app_exceptions.ServerException('Invalid data format');
    } on app_exceptions.ServerException {
      rethrow;
    } on app_exceptions.NetworkException {
      rethrow;
    } catch (e, stackTrace) {
      appLogger.e(
        'Unknown error fetching country $code',
        error: e,
        stackTrace: stackTrace,
      );
      throw app_exceptions.ServerException(e.toString());
    }
  }
}
