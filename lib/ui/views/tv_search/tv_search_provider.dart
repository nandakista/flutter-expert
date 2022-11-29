import 'package:flutter/cupertino.dart';
import 'package:submission/core/constant/network_state.dart';
import 'package:submission/domain/entities/tv.dart';
import 'package:submission/domain/usecases/search_tv.dart';

class TvSearchProvider extends ChangeNotifier {
  final SearchTv searchTv;
  TvSearchProvider({required this.searchTv});

  String _message = '';
  String get message => _message;

  RequestState _state = RequestState.initial;
  RequestState get state => _state;
  List<Tv> _data = <Tv>[];
  List<Tv> get data => _data;

  void toInitial() => _state = RequestState.initial;

  Future<void> onSearchTv(String query) async {
    _state = RequestState.loading;
    notifyListeners();

    final result = await searchTv(query);
    result.fold(
      (failure) {
        _message = failure.message;
        _state = RequestState.error;
        notifyListeners();
      },
      (tvData) {
        if (tvData.isEmpty) {
          _state = RequestState.empty;
          _message = 'Oops we could not find what you were looking for!';
          notifyListeners();
        } else {
          _data = tvData;
          _state = RequestState.success;
          notifyListeners();
        }
      },
    );
  }
}
