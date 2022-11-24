import 'package:flutter/cupertino.dart';
import 'package:submission/domain/usecases/get_detail_movie.dart';
import 'package:submission/domain/usecases/get_recommended_movies.dart';

import '../../../core/constant/network_state.dart';
import '../../../domain/entities/movie.dart';
import '../../../domain/entities/movie_detail.dart';

class DetailProvider extends ChangeNotifier {
  final GetDetailMovie getDetailMovie;
  final GetRecommendedMovies getRecommendationsMovies;

  DetailProvider({
    required this.getDetailMovie,
    required this.getRecommendationsMovies,
  });

  String _message = '';
  String get message => _message;

  NetworkState _detailState = NetworkState.empty;
  NetworkState get detailState => _detailState;
  late MovieDetail _detailMovie;
  MovieDetail get detailMovie => _detailMovie;

  NetworkState _recommendedState = NetworkState.empty;
  NetworkState get recommendationState => _recommendedState;
  List<Movie> _recommendedMovies = [];
  List<Movie> get recommendedMovies => _recommendedMovies;

  DetailProvider init(int id) {
    loadMovieDetail(id);
    loadRecommendedMovie(id);
    return this;
  }

  Future<void> loadMovieDetail(int id) async {
    _detailState = NetworkState.loading;
    notifyListeners();

    final detailResult = await getDetailMovie(id);
    detailResult.fold(
      (failure) {
        _detailState = NetworkState.error;
        _message = failure.message;
        notifyListeners();
      },
      (movie) {
        _detailMovie = movie;
        _detailState = NetworkState.loaded;
        notifyListeners();
      },
    );
  }

  Future<void> loadRecommendedMovie(int id) async {
    _recommendedState = NetworkState.loading;
    notifyListeners();

    final recommendationResult = await getRecommendationsMovies(id);
    recommendationResult.fold(
      (failure) {
        _message = failure.message;
        _recommendedState = NetworkState.error;
        notifyListeners();
      },
      (movies) {
        _recommendedMovies = movies;
        _recommendedState = NetworkState.loaded;
        notifyListeners();
      },
    );
  }
}
