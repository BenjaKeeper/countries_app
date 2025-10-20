import 'package:countries_app/core/di/injection.dart';
import 'package:countries_app/features/countries/domain/entities/country.dart';
import 'package:countries_app/features/countries/domain/usecases/get_country_details.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'country_details_provider.g.dart';

/// Provider for GetCountryDetails use case
@riverpod
GetCountryDetails getCountryDetailsUseCase(Ref ref) {
  return getIt<GetCountryDetails>();
}

/// Provider family for country details
@riverpod
Future<Country> countryDetails(Ref ref, String countryCode) async {
  final useCase = ref.read(getCountryDetailsUseCaseProvider);
  final result = await useCase(countryCode);

  return result.fold(
    (failure) => throw failure, // Preserve Failure type
    (country) => country,
  );
}

/// Provider family for "show more" state
@riverpod
class ShowMoreState extends _$ShowMoreState {
  @override
  bool build(String countryCode) => false;

  void toggle() {
    state = !state;
  }
}
