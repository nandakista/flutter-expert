import 'package:flutter/cupertino.dart';

import '../../../core/constant/network_state.dart';
import '../../../domain/entities/movie.dart';
import '../../../domain/entities/movie_detail.dart';
import '../../../domain/usecases/get_detail_movie.dart';
import '../../../domain/usecases/get_recommended_movies.dart';
import '../../../domain/usecases/get_watchlist_exist_status.dart';
import '../../../domain/usecases/remove_watchlist.dart';
import '../../../domain/usecases/save_watchlist.dart';

class DetailProvider extends ChangeNotifier {
  final GetDetailMovie getDetailMovie;
  final GetRecommendedMovies getRecommendationsMovies;
  final GetWatchlistExistStatus getWatchlistExist;
  final SaveWatchlist saveWatchlist;
  final RemoveWatchlist removeWatchlist;

  DetailProvider({
    required this.getDetailMovie,
    required this.getRecommendationsMovies,
    required this.getWatchlistExist,
    required this.saveWatchlist,
    required this.removeWatchlist,
  });

  String _message = '';
  String get message => _message;

  RequestState _detailState = RequestState.initial;
  RequestState get detailState => _detailState;
  late MovieDetail _detailMovie;
  MovieDetail get detailMovie => _detailMovie;

  RequestState _recommendedState = RequestState.initial;
  RequestState get recommendationState => _recommendedState;
  List<Movie> _recommendedMovies = [];
  List<Movie> get recommendedMovies => _recommendedMovies;

  Future<void> loadMovieDetail(int id) async {
    _detailState = RequestState.loading;
    notifyListeners();

    final detailResult = await getDetailMovie(id);
    detailResult.fold(
      (failure) {
        _detailState = RequestState.error;
        _message = failure.message;
        notifyListeners();
      },
      (movie) {
        _detailMovie = movie;
        _detailState = RequestState.success;
        notifyListeners();
      },
    );
  }

  Future<void> loadRecommendedMovie(int id) async {
    _recommendedState = RequestState.loading;
    notifyListeners();

    final recommendationResult = await getRecommendationsMovies(id);
    recommendationResult.fold(
      (failure) {
        _message = failure.message;
        _recommendedState = RequestState.error;
        notifyListeners();
      },
      (movies) {
        if (movies.isEmpty) {
          _message = 'No Recommendations Found';
          _recommendedState = RequestState.empty;
          notifyListeners();
        } else {
          _recommendedMovies = movies;
          _recommendedState = RequestState.success;
          notifyListeners();
        }
      },
    );
  }

  String _watchlistMessage = '';
  String get watchlistMessage => _watchlistMessage;

  bool _hasAddedToWatchlist = false;
  bool get hasAddedToWatchlist => _hasAddedToWatchlist;

  Future<void> addWatchlist(MovieDetail movie) async {
    final result = await saveWatchlist(movie);
    await result.fold(
      (failure) async {
        _watchlistMessage = failure.message;
      },
      (message) async {
        _watchlistMessage = message;
      },
    );
    await loadWatchlistExistStatus(movie.id!);
  }

  Future<void> removeFromWatchlist(MovieDetail movie) async {
    final result = await removeWatchlist(movie);
    await result.fold(
      (failure) async {
        _watchlistMessage = failure.message;
      },
      (message) async {
        _watchlistMessage = message;
      },
    );
    await loadWatchlistExistStatus(movie.id!);
  }

  Future<void> loadWatchlistExistStatus(int id) async {
    _hasAddedToWatchlist = await getWatchlistExist(id);
    notifyListeners();
  }
}
