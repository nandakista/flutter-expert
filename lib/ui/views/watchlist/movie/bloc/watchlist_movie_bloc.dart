import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:submission/domain/entities/movie.dart';
import 'package:submission/domain/usecases/get_watchlist_movie.dart';

part 'watchlist_movie_event.dart';

part 'watchlist_movie_state.dart';

class WatchlistMovieBloc
    extends Bloc<WatchlistMovieEvent, WatchlistMovieState> {
  final GetWatchlistMovie getWatchlist;

  WatchlistMovieBloc(this.getWatchlist) : super(WatchlistMovieInitial()) {
    on<LoadWatchlistMovie>((event, emit) async {
      emit(WatchlistMovieLoading());
      final result = await getWatchlist();
      result.fold(
        (failure) => emit(WatchlistMovieError(failure.message)),
        (data) {
          if(data.isEmpty) {
            emit(const WatchlistMovieEmpty('Empty Movie Watchlist'));
          } else {
            emit(WatchlistMovieHasData(data));
          }
        },
      );
    });
  }
}
