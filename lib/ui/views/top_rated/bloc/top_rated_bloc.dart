import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:submission/domain/entities/movie.dart';
import 'package:submission/domain/usecases/get_top_rated_movies.dart';

part 'top_rated_event.dart';

part 'top_rated_state.dart';

class TopRatedBloc extends Bloc<TopRatedEvent, TopRatedState> {
  final GetTopRatedMovies getTopRatedMovies;

  TopRatedBloc(this.getTopRatedMovies) : super(TopRatedInitial()) {
    on<LoadTopRatedMovies>((event, emit) async {
      emit(TopRatedLoading());
      final result = await getTopRatedMovies();
      result.fold(
        (failure) => emit(TopRatedError(failure.message)),
        (data) => emit(TopRatedHasData(data)),
      );
    });
  }
}
