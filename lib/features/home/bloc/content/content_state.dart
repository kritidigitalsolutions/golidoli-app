part of 'content_bloc.dart';

@freezed
abstract class ContentState with _$ContentState {
  const factory ContentState({
    @Default(Status.init) Status allContentStatus,
    @Default(null) HomeContentResponse? allContents,
  }) = _ContentState;
}
