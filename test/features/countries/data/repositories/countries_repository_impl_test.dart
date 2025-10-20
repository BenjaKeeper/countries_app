import 'package:countries_app/core/error/exceptions.dart';
import 'package:countries_app/core/error/failures.dart';
import 'package:countries_app/core/network/network_info.dart';
import 'package:countries_app/features/countries/data/datasources/countries_remote_datasource.dart';
import 'package:countries_app/features/countries/data/models/continent_model.dart';
import 'package:countries_app/features/countries/data/models/country_model.dart';
import 'package:countries_app/features/countries/data/models/language_model.dart';
import 'package:countries_app/features/countries/data/repositories/countries_repository_impl.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockCountriesRemoteDataSource extends Mock
    implements CountriesRemoteDataSource {}

class MockNetworkInfo extends Mock implements NetworkInfo {}

void main() {
  late CountriesRepositoryImpl repository;
  late MockCountriesRemoteDataSource mockRemoteDataSource;
  late MockNetworkInfo mockNetworkInfo;

  setUp(() {
    mockRemoteDataSource = MockCountriesRemoteDataSource();
    mockNetworkInfo = MockNetworkInfo();
    repository = CountriesRepositoryImpl(mockRemoteDataSource, mockNetworkInfo);
  });

  group('getAllCountries', () {
    final tCountryModels = [
      const CountryModel(
        code: 'US',
        name: 'United States',
        emoji: '🇺🇸',
        capital: 'Washington D.C.',
        currency: 'USD',
        phone: '+1',
        continent: ContinentModel(code: 'NA', name: 'North America'),
        languages: [
          LanguageModel(code: 'en', name: 'English'),
        ],
      ),
      const CountryModel(
        code: 'MX',
        name: 'Mexico',
        emoji: '🇲🇽',
        capital: 'Mexico City',
        currency: 'MXN',
        phone: '+52',
        continent: ContinentModel(code: 'NA', name: 'North America'),
        languages: [
          LanguageModel(code: 'es', name: 'Spanish'),
        ],
      ),
    ];

    test(
        'should return list of countries when call to data source is successful',
        () async {
      // Arrange
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(() => mockRemoteDataSource.getAllCountries())
          .thenAnswer((_) async => tCountryModels);

      // Act
      final result = await repository.getAllCountries();

      // Assert
      result.fold(
        (failure) => fail('Should be Right'),
        (countries) {
          expect(countries.length, equals(2));
          expect(countries[0].code, equals('US'));
          expect(countries[1].code, equals('MX'));
        },
      );
      verify(() => mockNetworkInfo.isConnected).called(1);
      verify(() => mockRemoteDataSource.getAllCountries()).called(1);
      verifyNoMoreInteractions(mockRemoteDataSource);
    });

    test('should return NetworkFailure when network is not connected',
        () async {
      // Arrange
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => false);

      // Act
      final result = await repository.getAllCountries();

      // Assert
      result.fold(
        (failure) => expect(failure, isA<Failure>()),
        (_) => fail('Should be Left'),
      );
      verify(() => mockNetworkInfo.isConnected).called(1);
      verifyNoMoreInteractions(mockRemoteDataSource);
    });

    test('should return ServerFailure when data source throws ServerException',
        () async {
      // Arrange
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(() => mockRemoteDataSource.getAllCountries())
          .thenThrow(ServerException('Server error'));

      // Act
      final result = await repository.getAllCountries();

      // Assert
      result.fold(
        (failure) => expect(failure, isA<Failure>()),
        (_) => fail('Should be Left'),
      );
      verify(() => mockNetworkInfo.isConnected).called(1);
      verify(() => mockRemoteDataSource.getAllCountries()).called(1);
    });

    test(
        'should return NetworkFailure when data source throws NetworkException',
        () async {
      // Arrange
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(() => mockRemoteDataSource.getAllCountries())
          .thenThrow(NetworkException());

      // Act
      final result = await repository.getAllCountries();

      // Assert
      result.fold(
        (failure) => expect(failure, isA<Failure>()),
        (_) => fail('Should be Left'),
      );
      verify(() => mockNetworkInfo.isConnected).called(1);
      verify(() => mockRemoteDataSource.getAllCountries()).called(1);
    });
  });

  group('getCountryByCode', () {
    const tCountryCode = 'US';
    const tCountryModel = CountryModel(
      code: 'US',
      name: 'United States',
      emoji: '🇺🇸',
      capital: 'Washington D.C.',
      currency: 'USD',
      phone: '+1',
      continent: ContinentModel(code: 'NA', name: 'North America'),
      languages: [
        LanguageModel(code: 'en', name: 'English'),
      ],
    );

    test('should return country when call to data source is successful',
        () async {
      // Arrange
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(() => mockRemoteDataSource.getCountryByCode(tCountryCode))
          .thenAnswer((_) async => tCountryModel);

      // Act
      final result = await repository.getCountryByCode(tCountryCode);

      // Assert
      result.fold(
        (failure) => fail('Should be Right'),
        (country) {
          expect(country.code, equals('US'));
          expect(country.name, equals('United States'));
        },
      );
      verify(() => mockNetworkInfo.isConnected).called(1);
      verify(() => mockRemoteDataSource.getCountryByCode(tCountryCode))
          .called(1);
      verifyNoMoreInteractions(mockRemoteDataSource);
    });

    test('should return NetworkFailure when network is not connected',
        () async {
      // Arrange
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => false);

      // Act
      final result = await repository.getCountryByCode(tCountryCode);

      // Assert
      result.fold(
        (failure) => expect(failure, isA<Failure>()),
        (_) => fail('Should be Left'),
      );
      verify(() => mockNetworkInfo.isConnected).called(1);
      verifyNoMoreInteractions(mockRemoteDataSource);
    });

    test('should return ServerFailure when data source throws ServerException',
        () async {
      // Arrange
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(() => mockRemoteDataSource.getCountryByCode(tCountryCode))
          .thenThrow(ServerException('Country not found'));

      // Act
      final result = await repository.getCountryByCode(tCountryCode);

      // Assert
      result.fold(
        (failure) => expect(failure, isA<Failure>()),
        (_) => fail('Should be Left'),
      );
      verify(() => mockNetworkInfo.isConnected).called(1);
      verify(() => mockRemoteDataSource.getCountryByCode(tCountryCode))
          .called(1);
    });

    test(
        'should return NetworkFailure when data source throws NetworkException',
        () async {
      // Arrange
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(() => mockRemoteDataSource.getCountryByCode(tCountryCode))
          .thenThrow(NetworkException());

      // Act
      final result = await repository.getCountryByCode(tCountryCode);

      // Assert
      result.fold(
        (failure) => expect(failure, isA<Failure>()),
        (_) => fail('Should be Left'),
      );
      verify(() => mockNetworkInfo.isConnected).called(1);
      verify(() => mockRemoteDataSource.getCountryByCode(tCountryCode))
          .called(1);
    });
  });
}
