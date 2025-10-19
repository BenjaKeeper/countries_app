import 'package:freezed_annotation/freezed_annotation.dart';

part 'failures.freezed.dart';

@freezed
class Failure with _$Failure {
  const factory Failure.server(String message) = ServerFailure;
  const factory Failure.network() = NetworkFailure;
  const factory Failure.unknown(String message) = UnknownFailure;
}
