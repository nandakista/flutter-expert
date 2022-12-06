import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:submission/domain/entities/tv.dart';
import 'package:submission/domain/usecases/get_popular_tv.dart';

part 'tv_popular_event.dart';

part 'tv_popular_state.dart';

class TvPopularBloc extends Bloc<TvPopularEvent, TvPopularState> {
  final GetPopularTv getPopularTv;

  TvPopularBloc(this.getPopularTv) : super(TvPopularInitial()) {
    on<LoadPopularTv>((event, emit) async {
      emit(TvPopularLoading());
      final result = await getPopularTv();
      result.fold(
        (failure) => emit(TvPopularError(failure.message)),
        (data) => emit(TvPopularHasData(data)),
      );
    });
  }
}
