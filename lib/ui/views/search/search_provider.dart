import 'package:flutter/cupertino.dart';
import 'package:submission/domain/usecases/search_movie.dart';

import '../../../core/constant/network_state.dart';
import '../../../domain/entities/movie.dart';

class SearchProvider extends ChangeNotifier {
  final SearchMovie searchMovie;
  SearchProvider({required this.searchMovie});

  String _message = '';
  String get message => _message;

  NetworkState _state = NetworkState.empty;
  NetworkState get state => _state;
  List<Movie> _data = <Movie>[];
  List<Movie> get data => _data;

  Future<void> onSearchMovie(String query) async {
    _state = NetworkState.loading;
    notifyListeners();

    final result = await searchMovie(query);
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