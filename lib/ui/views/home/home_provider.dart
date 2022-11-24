import 'package:flutter/cupertino.dart';

import '../../../core/constant/network_state.dart';
import '../../../domain/entities/movie.dart';
import '../../../domain/usecases/get_now_playing_movies.dart';

class HomeProvider extends ChangeNotifier {
  final GetNowPlayingMovies getNowPlayingMovies;
  HomeProvider({required this.getNowPlayingMovies});

  String _message = '';
  String get message => _message;

  NetworkState _state = NetworkState.empty;
  NetworkState get state => _state;
  List<Movie> _data = <Movie>[];
  List<Movie> get data => _data;

  HomeProvider init() {
    loadData();
    return this;
  }

  Future<void> loadData() async {
    _state = NetworkState.loading;
    notifyListeners();

    final result = await getNowPlayingMovies();
    result.fold(
      (failure) {
        _message = failure.message;
        _state = NetworkState.error;
        notifyListeners();
      },
      (moviesData) {
        _data = moviesData;
        _state = NetworkState.loaded;
        notifyListeners();
      },
    );
  }
}
