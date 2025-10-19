import 'package:countries_app/core/error/failures.dart';
import 'package:countries_app/features/countries/domain/entities/country.dart';
import 'package:dartz/dartz.dart';

abstract class CountriesRepository {
  Future<Either<Failure, List<Country>>> getAllCountries();
  Future<Either<Failure, Country>> getCountryByCode(String code);
}
