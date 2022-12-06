import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:submission/domain/entities/movie.dart';
import 'package:submission/domain/usecases/get_popular_movies.dart';

part 'popular_event.dart';

part 'popular_state.dart';

class PopularBloc extends Bloc<PopularEvent, PopularState> {
  final GetPopularMovies getPopularMovies;

  PopularBloc(this.getPopularMovies) : super(PopularInitial()) {
    on<LoadPopularMovies>((event, emit) async {
      emit(PopularLoading());
      final result = await getPopularMovies();
      result.fold(
        (failure) => emit(PopularError(failure.message)),
        (data) => emit(PopularHasData(data)),
      );
    });
  }
}
