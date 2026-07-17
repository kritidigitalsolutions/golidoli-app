part of 'help_cubit.dart';

@freezed
abstract class HelpState with _$HelpState {
  const factory HelpState({
    @Default(null) HelpResponse? helps,
    @Default(Status.init) Status helpStatus,
    @Default(null)DocumentModel? documents,
    @Default(Status.init)Status documentStatus,
  }) = _HelpState;
}

