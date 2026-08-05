import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:golidoli_app/features/home/models/category_model.dart';
import 'package:golidoli_app/features/home/models/category_detail_model.dart';
import 'package:golidoli_app/features/home/usecases/all_categories_usecase.dart';
import 'package:golidoli_app/features/home/usecases/category_detail_usecase.dart';

import '../../../../constants/enums.dart';

part 'category_event.dart';
part 'category_state.dart';
part 'category_bloc.freezed.dart';

class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  final AllCategoriesUsecase _allCategoriesUsecase;
  final CategoryDetailUsecase _categoryDetailUsecase;
  CategoryBloc({
    required AllCategoriesUsecase allCategoriesUsecase,
    required CategoryDetailUsecase categoryDetailUsecase,
  }) : _allCategoriesUsecase = allCategoriesUsecase,
       _categoryDetailUsecase = categoryDetailUsecase,
       super(const CategoryState()) {
    on<_AllCategory>((event, emit) async {
      emit(state.copyWith(categoryStatus: Status.loading));
      final result = await _allCategoriesUsecase();
      if (result != null) {
        emit(
          state.copyWith(allCategories: result, categoryStatus: Status.success),
        );
      } else {
        emit(state.copyWith(categoryStatus: Status.error));
      }
    });
    on<_DetailCategory>((event, emit) async {
      emit(
        state.copyWith(
          detailCategoryStatus: Status.loading,
          pageNo: 0,
          hasMore: true,
        ),
      );

      final result = await _categoryDetailUsecase(
        id: event.id,
        page: 0,
        size: state.pageSize,
      );

      if (result != null) {
        emit(
          state.copyWith(
            categoryDetail: result,
            detailCategoryStatus: Status.success,
            pageNo: 0,
            hasMore: result.content.length == state.pageSize,
          ),
        );
      } else {
        emit(state.copyWith(detailCategoryStatus: Status.error));
      }
    });
    on<_LoadMore>((event, emit) async {
      if (state.detailCategoryStatus == Status.loading || !state.hasMore) {
        return;
      }

      emit(state.copyWith(detailCategoryStatus: Status.loading));

      final nextPage = state.pageNo + 1;

      final result = await _categoryDetailUsecase(
        id: event.id,
        page: nextPage,
        size: state.pageSize,
      );

      if (result != null) {
        final oldContent = state.categoryDetail?.content ?? [];

        final updatedContent = [...oldContent, ...result.content];

        emit(
          state.copyWith(
            pageNo: nextPage,
            hasMore: result.content.length == state.pageSize,
            detailCategoryStatus: Status.success,
            categoryDetail: result.copyWith(content: updatedContent),
          ),
        );
      } else {
        emit(state.copyWith(detailCategoryStatus: Status.error));
      }
    });
  }
}
