part of 'category_bloc.dart';

@freezed
class CategoryEvent with _$CategoryEvent {
  const factory CategoryEvent.allCategory() = _AllCategory;
  const factory CategoryEvent.detailCategory({required String id}) = _DetailCategory;
  const factory CategoryEvent.loadMore({required String id}) = _LoadMore;
}
