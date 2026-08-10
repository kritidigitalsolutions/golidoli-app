part of 'content_bloc.dart';

@freezed
abstract class ContentState with _$ContentState {
  const factory ContentState({
    @Default(Status.init) Status allContentStatus,
    @Default(null) HomeContentResponse? allContents,
    @Default(Status.init) Status searchContentStatus,
    @Default(null) HomeContentResponse? searchContents,
  }) = _ContentState;
}
