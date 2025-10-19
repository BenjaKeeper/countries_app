import 'package:countries_app/core/error/failures.dart';
import 'package:countries_app/features/countries/domain/entities/country.dart';
import 'package:countries_app/features/countries/domain/repositories/countries_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class GetAllCountries {
  final CountriesRepository repository;

  GetAllCountries(this.repository);

  Future<Either<Failure, List<Country>>> call() {
    return repository.getAllCountries();
  }
}
