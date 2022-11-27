import 'package:flutter/cupertino.dart';

import '../../../core/constant/network_state.dart';
import '../../../domain/entities/movie.dart';
import '../../../domain/usecases/get_watchlist.dart';

class WatchlistProvider extends ChangeNotifier {
  final GetWatchlist getWatchlist;
  WatchlistProvider({required this.getWatchlist});

  String _message = '';
  String get message => _message;

  List<Movie> _data = <Movie>[];
  List<Movie> get data => _data;
  RequestState _state = RequestState.initial;
  RequestState get state => _state;

  Future<void> loadData() async {
    _state = RequestState.loading;
    notifyListeners();

    final result = await getWatchlist();
    result.fold(
      (failure) {
        _state = RequestState.error;
        _message = failure.message;
        notifyListeners();
      },
      (moviesData) {
        if(moviesData.isEmpty) {
          _state = RequestState.empty;
          _message = 'Empty Watchlist';
          notifyListeners();
        } else {
          _state = RequestState.success;
          _data = moviesData;
          notifyListeners();
        }
      },
    );
  }
}
