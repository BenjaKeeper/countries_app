import 'package:countries_app/core/error/failures.dart';
import 'package:countries_app/features/countries/domain/entities/continent.dart';
import 'package:countries_app/features/countries/domain/entities/country.dart';
import 'package:countries_app/features/countries/domain/entities/language.dart';
import 'package:countries_app/features/countries/domain/repositories/countries_repository.dart';
import 'package:countries_app/features/countries/domain/usecases/get_country_details.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockCountriesRepository extends Mock implements CountriesRepository {}

void main() {
  late GetCountryDetails useCase;
  late MockCountriesRepository mockRepository;

  setUp(() {
    mockRepository = MockCountriesRepository();
    useCase = GetCountryDetails(mockRepository);
  });

  group('GetCountryDetails', () {
    const tCountryCode = 'US';
    const tCountry = Country(
      code: 'US',
      name: 'United States',
      emoji: '🇺🇸',
      capital: 'Washington D.C.',
      currency: 'USD',
      phone: '+1',
      continent: Continent(code: 'NA', name: 'North America'),
      languages: [
        Language(code: 'en', name: 'English'),
      ],
    );

    test('should return country details from repository', () async {
      // Arrange
      when(() => mockRepository.getCountryByCode(tCountryCode))
          .thenAnswer((_) async => const Right(tCountry));

      // Act
      final result = await useCase(tCountryCode);

      // Assert
      expect(result, const Right(tCountry));
      verify(() => mockRepository.getCountryByCode(tCountryCode)).called(1);
      verifyNoMoreInteractions(mockRepository);
    });

    test('should return ServerFailure when repository fails', () async {
      // Arrange
      const tFailure = Failure.server('Country not found');
      when(() => mockRepository.getCountryByCode(tCountryCode))
          .thenAnswer((_) async => const Left(tFailure));

      // Act
      final result = await useCase(tCountryCode);

      // Assert
      expect(result, const Left(tFailure));
      verify(() => mockRepository.getCountryByCode(tCountryCode)).called(1);
      verifyNoMoreInteractions(mockRepository);
    });

    test('should return NetworkFailure when there is no network', () async {
      // Arrange
      const tFailure = Failure.network();
      when(() => mockRepository.getCountryByCode(tCountryCode))
          .thenAnswer((_) async => const Left(tFailure));

      // Act
      final result = await useCase(tCountryCode);

      // Assert
      expect(result, const Left(tFailure));
      verify(() => mockRepository.getCountryByCode(tCountryCode)).called(1);
      verifyNoMoreInteractions(mockRepository);
    });

    test('should pass correct country code to repository', () async {
      // Arrange
      const tCustomCode = 'MX';
      const tMexicoCountry = Country(
        code: 'MX',
        name: 'Mexico',
        emoji: '🇲🇽',
        capital: 'Mexico City',
        currency: 'MXN',
        phone: '+52',
        continent: Continent(code: 'NA', name: 'North America'),
        languages: [
          Language(code: 'es', name: 'Spanish'),
        ],
      );

      when(() => mockRepository.getCountryByCode(tCustomCode))
          .thenAnswer((_) async => const Right(tMexicoCountry));

      // Act
      final result = await useCase(tCustomCode);

      // Assert
      expect(result, const Right(tMexicoCountry));
      verify(() => mockRepository.getCountryByCode(tCustomCode)).called(1);
      verifyNoMoreInteractions(mockRepository);
    });
  });
}
