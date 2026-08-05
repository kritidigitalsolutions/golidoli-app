import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:golidoli_app/constants/enums.dart';
import 'package:golidoli_app/features/home/models/content_model.dart';
import 'package:golidoli_app/features/home/usecases/all_content_usecase.dart';

part 'content_event.dart';
part 'content_state.dart';
part 'content_bloc.freezed.dart';

class ContentBloc extends Bloc<ContentEvent, ContentState> {
  final AllContentUsecase _allContentUsecase;
  ContentBloc({required AllContentUsecase allContentUsecase})
    : _allContentUsecase = allContentUsecase,
      super(const ContentState()) {
    on<_AllContent>((event, emit) async {
      emit(state.copyWith(allContentStatus: Status.loading));
      final result = await _allContentUsecase();
      if (result != null) {
        emit(
          state.copyWith(allContentStatus: Status.success, allContents: result),
        );
      } else {
        emit(state.copyWith(allContentStatus: Status.error));
      }
    });
  }
}
