import 'package:flutter/cupertino.dart';
import 'package:submission/domain/usecases/search_movie.dart';

import '../../../core/constant/network_state.dart';
import '../../../domain/entities/movie.dart';

class SearchProvider extends ChangeNotifier {
  final SearchMovie searchMovie;
  SearchProvider({required this.searchMovie});

  String _message = '';
  String get message => _message;

  RequestState _state = RequestState.initial;
  RequestState get state => _state;
  List<Movie> _data = <Movie>[];
  List<Movie> get data => _data;

  void toInitial() => _state = RequestState.initial;

  Future<void> onSearchMovie(String query) async {
    _state = RequestState.loading;
    notifyListeners();

    final result = await searchMovie(query);
    result.fold(
      (failure) {
        _message = failure.message;
        _state = RequestState.error;
        notifyListeners();
      },
      (moviesData) {
        if(moviesData.isEmpty) {
          _state = RequestState.empty;
          _message = 'Oops we could not find what you were looking for!';
          notifyListeners();
        } else {
          _data = moviesData;
          _state = RequestState.success;
          notifyListeners();
        }
      },
    );
  }
}
