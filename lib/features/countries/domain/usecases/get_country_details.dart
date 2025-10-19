import 'package:countries_app/core/error/failures.dart';
import 'package:countries_app/features/countries/domain/entities/country.dart';
import 'package:countries_app/features/countries/domain/repositories/countries_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class GetCountryDetails {
  final CountriesRepository repository;

  GetCountryDetails(this.repository);

  Future<Either<Failure, Country>> call(String countryCode) {
    return repository.getCountryByCode(countryCode);
  }
}
