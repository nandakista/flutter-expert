import 'package:flutter/cupertino.dart';
import 'package:submission/core/constant/network_state.dart';
import 'package:submission/domain/entities/tv.dart';
import 'package:submission/domain/usecases/get_popular_tv.dart';

class TvPopularProvider extends ChangeNotifier {
  final GetPopularTv getPopularTv;
  TvPopularProvider({required this.getPopularTv});

  String _message = '';
  String get message => _message;

  RequestState _state = RequestState.initial;
  RequestState get state => _state;
  List<Tv> _data = <Tv>[];
  List<Tv> get data => _data;

  TvPopularProvider init() {
    loadData();
    return this;
  }

  Future<void> loadData() async {
    _state = RequestState.loading;
    notifyListeners();
    final result = await getPopularTv();
    result.fold(
      (failure) {
        _message = failure.message;
        _state = RequestState.error;
        notifyListeners();
      },
      (tvData) {
        if (tvData.isEmpty) {
          _state = RequestState.empty;
          _message = 'Empty Popular TV Series';
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
