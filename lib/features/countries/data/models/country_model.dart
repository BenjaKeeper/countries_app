import 'package:countries_app/features/countries/data/models/continent_model.dart';
import 'package:countries_app/features/countries/data/models/language_model.dart';
import 'package:countries_app/features/countries/domain/entities/country.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'country_model.freezed.dart';
part 'country_model.g.dart';

@freezed
abstract class CountryModel with _$CountryModel {
  const CountryModel._();

  const factory CountryModel({
    required String code,
    required String name,
    required String emoji,
    String? capital,
    String? currency,
    String? phone,
    required ContinentModel continent,
    required List<LanguageModel> languages,
  }) = _CountryModel;

  factory CountryModel.fromJson(Map<String, dynamic> json) =>
      _$CountryModelFromJson(json);

  Country toEntity() {
    return Country(
      code: code,
      name: name,
      emoji: emoji,
      capital: capital,
      currency: currency,
      phone: phone,
      continent: continent.toEntity(),
      languages: languages.map((l) => l.toEntity()).toList(),
    );
  }
}
