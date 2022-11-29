import 'package:flutter/cupertino.dart';
import 'package:submission/core/constant/network_state.dart';
import 'package:submission/domain/entities/tv.dart';
import 'package:submission/domain/usecases/get_watchlist_tv.dart';

class WatchlistTvProvider extends ChangeNotifier {
  final GetWatchlistTv getWatchlist;
  WatchlistTvProvider({required this.getWatchlist});

  String _message = '';
  String get message => _message;

  List<Tv> _data = <Tv>[];
  List<Tv> get data => _data;
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
      (tvData) {
        if (tvData.isEmpty) {
          _state = RequestState.empty;
          _message = 'Empty Tv Watchlist';
          notifyListeners();
        } else {
          _state = RequestState.success;
          _data = tvData;
          notifyListeners();
        }
      },
    );
  }
}
