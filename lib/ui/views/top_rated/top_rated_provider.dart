import 'package:flutter/cupertino.dart';

import '../../../core/constant/network_state.dart';
import '../../../domain/entities/movie.dart';
import '../../../domain/usecases/get_top_rated_movies.dart';

class TopRatedProvider extends ChangeNotifier {
  final GetTopRatedMovies getTopRatedMovies;
  TopRatedProvider({required this.getTopRatedMovies});

  String _message = '';
  String get message => _message;

  NetworkState _state = NetworkState.empty;
  NetworkState get state => _state;
  List<Movie> _data = <Movie>[];
  List<Movie> get data => _data;

  TopRatedProvider init() {
    loadData();
    return this;
  }

  Future<void> loadData() async {
    _state = NetworkState.loading;
    notifyListeners();

    final result = await getTopRatedMovies();
    result.fold(
      (failure) {
        _state = NetworkState.error;
        _message = failure.message;
        notifyListeners();
      },
      (moviesData) {
        _state = NetworkState.loaded;
        _data = moviesData;
        notifyListeners();
      },
    );
  }
}
