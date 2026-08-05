part of 'category_bloc.dart';

@freezed
abstract class CategoryState with _$CategoryState {
  const factory CategoryState({
    @Default(null) CategoriesResponse? allCategories,
    @Default(Status.init) Status categoryStatus,
    @Default(Status.init) Status detailCategoryStatus,
    @Default(null) CategoryContentResponse? categoryDetail,
    @Default(0) int pageNo,
    @Default(10) int pageSize,
    @Default(false)bool hasMore,
  }) = _CategoryState;
}
