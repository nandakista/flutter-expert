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

  NetworkState _movieState = NetworkState.empty;
  NetworkState get movieState => _movieState;
  late MovieDetail _movie;
  MovieDetail get movie => _movie;

  NetworkState _recommendationState = NetworkState.empty;
  NetworkState get recommendationState => _recommendationState;
  List<Movie> _movieRecommendations = [];
  List<Movie> get movieRecommendations => _movieRecommendations;


  DetailProvider init(int id) {
    fetchMovieDetail(id);
    return this;
  }

  Future<void> fetchMovieDetail(int id) async {
    _movieState = NetworkState.loading;
    notifyListeners();
    final detailResult = await getDetailMovie(id);
    final recommendationResult = await getRecommendationsMovies(id);
    detailResult.fold(
      (failure) {
        _movieState = NetworkState.error;
        _message = failure.message;
        notifyListeners();
      },
      (movie) {
        _recommendationState = NetworkState.loading;
        _movie = movie;
        notifyListeners();
        recommendationResult.fold(
          (failure) {
            _recommendationState = NetworkState.error;
            _message = failure.message;
          },
          (movies) {
            _recommendationState = NetworkState.loaded;
            _movieRecommendations = movies;
          },
        );
        _movieState = NetworkState.loaded;
        notifyListeners();
      },
    );
  }
}
