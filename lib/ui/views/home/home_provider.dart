import 'package:flutter/cupertino.dart';

import '../../../core/constant/network_state.dart';
import '../../../domain/entities/movie.dart';
import '../../../domain/usecases/get_now_playing_movies.dart';
import '../../../domain/usecases/get_popular_movies.dart';
import '../../../domain/usecases/get_top_rated_movies.dart';

class HomeProvider extends ChangeNotifier {
  final GetNowPlayingMovies getNowPlayingMovies;
  final GetPopularMovies getPopularMovies;
  final GetTopRatedMovies getTopRatedMovies;

  HomeProvider({
    required this.getNowPlayingMovies,
    required this.getPopularMovies,
    required this.getTopRatedMovies,
  });

  String _message = '';
  String get message => _message;

  NetworkState _nowPlayingState = NetworkState.empty;
  NetworkState get nowPlayingState => _nowPlayingState;
  List<Movie> _nowPlayingMovies = <Movie>[];
  List<Movie> get nowPlayingMovies => _nowPlayingMovies;

  NetworkState _popularState = NetworkState.empty;
  NetworkState get popularState => _popularState;
  List<Movie> _popularMovies = <Movie>[];
  List<Movie> get popularMovies => _popularMovies;

  NetworkState _topRateState = NetworkState.empty;
  NetworkState get topRateState => _topRateState;
  List<Movie> _topRateMovies = <Movie>[];
  List<Movie> get topRateMovies => _topRateMovies;

  HomeProvider init() {
    loadNowPlayingMovies();
    loadPopularMovies();
    loadTopRateMovies();
    return this;
  }

  Future<void> loadNowPlayingMovies() async {
    _nowPlayingState = NetworkState.loading;
    notifyListeners();

    final result = await getNowPlayingMovies();
    result.fold(
      (failure) {
        _nowPlayingState = NetworkState.error;
        _message = failure.message;
        notifyListeners();
      },
      (moviesData) {
        _nowPlayingState = NetworkState.loaded;
        _nowPlayingMovies = moviesData;
        notifyListeners();
      },
    );
  }

  Future<void> loadPopularMovies() async {
    _popularState = NetworkState.loading;
    notifyListeners();

    final result = await getPopularMovies();
    result.fold(
      (failure) {
        _popularState = NetworkState.error;
        _message = failure.message;
        notifyListeners();
      },
      (moviesData) {
        _popularState = NetworkState.loaded;
        _popularMovies = moviesData;
        notifyListeners();
      },
    );
  }

  Future<void> loadTopRateMovies() async {
    _topRateState = NetworkState.loading;
    notifyListeners();

    final result = await getTopRatedMovies();
    result.fold(
      (failure) {
        _topRateState = NetworkState.error;
        _message = failure.message;
        notifyListeners();
      },
      (moviesData) {
        _topRateState = NetworkState.loaded;
        _topRateMovies = moviesData;
        notifyListeners();
      },
    );
  }
}
