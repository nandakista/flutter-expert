import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:submission/domain/entities/movie.dart';
import 'package:submission/domain/entities/movie_detail.dart';
import 'package:submission/domain/usecases/get_detail_movie.dart';
import 'package:submission/domain/usecases/get_recommended_movies.dart';
import 'package:submission/domain/usecases/get_watchlist_movie_exist_status.dart';
import 'package:submission/domain/usecases/remove_watchlist_movie.dart';
import 'package:submission/domain/usecases/save_watchlist_movie.dart';

part 'detail_event.dart';

part 'detail_state.dart';

class DetailBloc extends Bloc<DetailEvent, DetailState> {
  final GetDetailMovie getDetailMovie;
  final GetRecommendedMovies getRecommendationsMovies;
  final GetWatchlistMovieExistStatus getWatchlistExist;
  final SaveWatchlistMovie saveWatchlist;
  final RemoveWatchlistMovie removeWatchlist;

  DetailBloc({
    required this.getDetailMovie,
    required this.getRecommendationsMovies,
    required this.getWatchlistExist,
    required this.saveWatchlist,
    required this.removeWatchlist,
  }) : super(DetailInitial()) {
    on<LoadDetailMovies>((event, emit) async {
      emit(DetailLoading());
      final detailResult = await getDetailMovie(event.id);
      final recommendedResult = await getRecommendationsMovies(event.id);
      final watchlistStatus = await getWatchlistExist(event.id);
      detailResult.fold(
        (failure) => emit(DetailError(failure.message)),
        (data) {
          recommendedResult.fold(
            (failure) => emit(DetailError(failure.message)),
            (recommended) {
              emit(DetailHasData(
                detail: data,
                recommendedMovie: recommended,
                hasAddedToWatchList: watchlistStatus,
              ));
            },
          );
        },
      );
    });

    on<AddWatchlist>((event, emit) async {
      final result = await saveWatchlist(event.movie);
      await result.fold(
        (failure) async {
          emit(
            DetailHasData(
              detail: event.movie,
              recommendedMovie: event.recommendation,
              watchlistMessage: failure.message,
              hasAddedToWatchList: false,
            ),
          );
        },
        (message) async {
          emit(
            DetailHasData(
              detail: event.movie,
              recommendedMovie: event.recommendation,
              watchlistMessage: message,
              hasAddedToWatchList: true,
            ),
          );
        },
      );
    });

    on<RemoveFromWatchlist>((event, emit) async {
      final result = await removeWatchlist(event.movie);
      await result.fold(
        (failure) async {
          emit(
            DetailHasData(
              detail: event.movie,
              recommendedMovie: event.recommendation,
              watchlistMessage: failure.message,
              hasAddedToWatchList: true,
            ),
          );
        },
        (message) async {
          emit(
            DetailHasData(
              detail: event.movie,
              recommendedMovie: event.recommendation,
              watchlistMessage: message,
              hasAddedToWatchList: false,
            ),
          );
        },
      );
    });
  }
}
