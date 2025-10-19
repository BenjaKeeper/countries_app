import 'package:freezed_annotation/freezed_annotation.dart';

part 'language.freezed.dart';

@freezed
abstract class Language with _$Language {
  const factory Language({
    required String code,
    required String name,
  }) = _Language;
}
