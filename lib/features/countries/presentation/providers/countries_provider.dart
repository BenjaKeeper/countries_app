import 'dart:async';

import 'package:countries_app/core/di/injection.dart';
import 'package:countries_app/features/countries/domain/entities/country.dart';
import 'package:countries_app/features/countries/domain/usecases/get_all_countries.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'countries_provider.g.dart';

/// Provider for GetAllCountries use case
@riverpod
GetAllCountries getAllCountriesUseCase(Ref ref) {
  return getIt<GetAllCountries>();
}

/// Provider for countries list
@riverpod
Future<List<Country>> countriesList(Ref ref) async {
  final useCase = ref.read(getAllCountriesUseCaseProvider);
  final result = await useCase();

  return result.fold(
    (failure) => throw failure, // Preserve Failure type
    (countries) => countries,
  );
}

/// Provider for search query with debounce
@riverpod
class CountriesSearch extends _$CountriesSearch {
  Timer? _debounce;
  String _pendingValue = '';

  @override
  String build() {
    ref.onDispose(() {
      _debounce?.cancel();
    });
    return '';
  }

  void update(String value) {
    _pendingValue = value;

    // Cancel previous timer
    _debounce?.cancel();

    // Set new timer for debounce
    _debounce = Timer(const Duration(milliseconds: 300), () {
      state = _pendingValue;
    });
  }

  void clear() {
    _debounce?.cancel();
    _pendingValue = '';
    state = '';
  }
}

/// Provider for filtered countries
@riverpod
Future<List<Country>> filteredCountries(Ref ref) async {
  final countries = await ref.watch(countriesListProvider.future);
  final searchQuery = ref.watch(countriesSearchProvider);

  if (searchQuery.isEmpty) {
    return countries;
  }

  return countries.where((country) {
    return country.name.toLowerCase().contains(searchQuery.toLowerCase()) ||
        country.code.toLowerCase().contains(searchQuery.toLowerCase());
  }).toList();
}
