import 'package:countries_app/features/countries/domain/entities/continent.dart';
import 'package:countries_app/features/countries/domain/entities/language.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'country.freezed.dart';

@freezed
abstract class Country with _$Country {
  const factory Country({
    required String code,
    required String name,
    required String emoji,
    required Continent continent,
    required List<Language> languages,
    String? capital,
    String? currency,
    String? phone,
  }) = _Country;
}
