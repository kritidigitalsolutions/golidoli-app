part of 'content_bloc.dart';

@freezed
class ContentEvent with _$ContentEvent {
  const factory ContentEvent.allContent() = _AllContent;
  const factory ContentEvent.searchContent({required String query}) = _SearchContent;
}
