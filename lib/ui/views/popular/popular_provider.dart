import 'package:flutter/cupertino.dart';
import 'package:submission/domain/usecases/get_popular_movies.dart';

import '../../../core/constant/network_state.dart';
import '../../../domain/entities/movie.dart';

class PopularProvider extends ChangeNotifier {
  final GetPopularMovies getPopularMovies;
  PopularProvider({required this.getPopularMovies});

  String _message = '';
  String get message => _message;

  NetworkState _state = NetworkState.initial;
  NetworkState get state => _state;
  List<Movie> _data = <Movie>[];
  List<Movie> get data => _data;

  PopularProvider init() {
    loadData();
    return this;
  }

  Future<void> loadData() async {
    _state = NetworkState.loading;
    notifyListeners();
    final result = await getPopularMovies();
    result.fold(
      (failure) {
        _message = failure.message;
        _state = NetworkState.error;
        notifyListeners();
      },
      (moviesData) {
        if(moviesData.isEmpty) {
          _state = NetworkState.empty;
          _message = 'Empty Popular Movies';
          notifyListeners();
        } else {
          _data = moviesData;
          _state = NetworkState.loaded;
          notifyListeners();
        }
      },
    );
  }
}
