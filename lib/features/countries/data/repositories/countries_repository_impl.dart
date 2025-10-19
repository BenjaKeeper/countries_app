import 'package:countries_app/core/error/exceptions.dart' as app_exceptions;
import 'package:countries_app/core/error/failures.dart';
import 'package:countries_app/core/logging/app_logger.dart';
import 'package:countries_app/core/network/network_info.dart';
import 'package:countries_app/features/countries/data/datasources/countries_remote_datasource.dart';
import 'package:countries_app/features/countries/domain/entities/country.dart';
import 'package:countries_app/features/countries/domain/repositories/countries_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: CountriesRepository)
class CountriesRepositoryImpl implements CountriesRepository {
  final CountriesRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  CountriesRepositoryImpl(this.remoteDataSource, this.networkInfo);

  @override
  Future<Either<Failure, List<Country>>> getAllCountries() async {
    // Check network connectivity first
    if (!await networkInfo.isConnected) {
      appLogger.w('No internet connection available');
      return const Left(Failure.network());
    }

    try {
      final models = await remoteDataSource.getAllCountries();
      final entities = models.map((m) => m.toEntity()).toList();
      return Right(entities);
    } on app_exceptions.ServerException catch (e) {
      appLogger.e('Server exception: ${e.message}');
      return Left(Failure.server(e.message));
    } on app_exceptions.NetworkException {
      appLogger.e('Network exception');
      return const Left(Failure.network());
    } catch (e) {
      appLogger.e('Unknown exception: $e');
      return Left(Failure.unknown(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Country>> getCountryByCode(String code) async {
    // Check network connectivity first
    if (!await networkInfo.isConnected) {
      appLogger.w('No internet connection available');
      return const Left(Failure.network());
    }

    try {
      final model = await remoteDataSource.getCountryByCode(code);
      return Right(model.toEntity());
    } on app_exceptions.ServerException catch (e) {
      appLogger.e('Server exception for country $code: ${e.message}');
      return Left(Failure.server(e.message));
    } on app_exceptions.NetworkException {
      appLogger.e('Network exception for country $code');
      return const Left(Failure.network());
    } catch (e) {
      appLogger.e('Unknown exception for country $code: $e');
      return Left(Failure.unknown(e.toString()));
    }
  }
}
