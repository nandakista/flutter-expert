import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:submission/domain/entities/movie.dart';
import 'package:submission/domain/entities/tv.dart';
import 'package:submission/domain/usecases/get_top_rated_movies.dart';
import 'package:submission/domain/usecases/get_top_rated_tv.dart';

part 'tv_top_rated_event.dart';

part 'tv_top_rated_state.dart';

class TvTopRatedBloc extends Bloc<TopRatedEvent, TvTopRatedState> {
  final GetTopRatedTv getTopRatedTv;

  TvTopRatedBloc(this.getTopRatedTv) : super(TvTopRatedInitial()) {
    on<LoadTopRatedTv>((event, emit) async {
      emit(TvTopRatedLoading());
      final result = await getTopRatedTv();
      result.fold(
        (failure) => emit(TvTopRatedError(failure.message)),
        (data) => emit(TvTopRatedHasData(data)),
      );
    });
  }
}
