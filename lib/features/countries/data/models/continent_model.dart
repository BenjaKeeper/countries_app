import 'package:countries_app/features/countries/domain/entities/continent.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'continent_model.freezed.dart';
part 'continent_model.g.dart';

@freezed
abstract class ContinentModel with _$ContinentModel {
  const ContinentModel._();

  const factory ContinentModel({required String name, String? code}) =
      _ContinentModel;

  factory ContinentModel.fromJson(Map<String, dynamic> json) =>
      _$ContinentModelFromJson(json);

  Continent toEntity() {
    return Continent(code: code, name: name);
  }
}
