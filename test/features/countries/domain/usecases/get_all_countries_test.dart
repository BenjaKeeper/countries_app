import 'package:countries_app/core/error/failures.dart';
import 'package:countries_app/features/countries/domain/entities/continent.dart';
import 'package:countries_app/features/countries/domain/entities/country.dart';
import 'package:countries_app/features/countries/domain/entities/language.dart';
import 'package:countries_app/features/countries/domain/repositories/countries_repository.dart';
import 'package:countries_app/features/countries/domain/usecases/get_all_countries.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockCountriesRepository extends Mock implements CountriesRepository {}

void main() {
  late GetAllCountries useCase;
  late MockCountriesRepository mockRepository;

  setUp(() {
    mockRepository = MockCountriesRepository();
    useCase = GetAllCountries(mockRepository);
  });

  group('GetAllCountries', () {
    final tCountries = [
      const Country(
        code: 'US',
        name: 'United States',
        emoji: '🇺🇸',
        capital: 'Washington D.C.',
        currency: 'USD',
        phone: '+1',
        continent: Continent(code: 'NA', name: 'North America'),
        languages: [Language(code: 'en', name: 'English')],
      ),
      const Country(
        code: 'MX',
        name: 'Mexico',
        emoji: '🇲🇽',
        capital: 'Mexico City',
        currency: 'MXN',
        phone: '+52',
        continent: Continent(code: 'NA', name: 'North America'),
        languages: [Language(code: 'es', name: 'Spanish')],
      ),
    ];

    test('should return list of countries from repository', () async {
      // Arrange
      when(
        () => mockRepository.getAllCountries(),
      ).thenAnswer((_) async => Right(tCountries));

      // Act
      final result = await useCase();

      // Assert
      expect(result, Right(tCountries));
      verify(() => mockRepository.getAllCountries()).called(1);
      verifyNoMoreInteractions(mockRepository);
    });

    test('should return ServerFailure when repository fails', () async {
      // Arrange
      const tFailure = Failure.server('Server error');
      when(
        () => mockRepository.getAllCountries(),
      ).thenAnswer((_) async => const Left(tFailure));

      // Act
      final result = await useCase();

      // Assert
      expect(result, const Left(tFailure));
      verify(() => mockRepository.getAllCountries()).called(1);
      verifyNoMoreInteractions(mockRepository);
    });

    test('should return NetworkFailure when there is no network', () async {
      // Arrange
      const tFailure = Failure.network();
      when(
        () => mockRepository.getAllCountries(),
      ).thenAnswer((_) async => const Left(tFailure));

      // Act
      final result = await useCase();

      // Assert
      expect(result, const Left(tFailure));
      verify(() => mockRepository.getAllCountries()).called(1);
      verifyNoMoreInteractions(mockRepository);
    });
  });
}
