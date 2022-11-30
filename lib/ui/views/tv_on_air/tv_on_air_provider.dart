import 'package:flutter/cupertino.dart';
import 'package:submission/core/constant/network_state.dart';
import 'package:submission/domain/entities/tv.dart';
import 'package:submission/domain/usecases/get_on_air_tv.dart';

class TvOnAirProvider extends ChangeNotifier {
  final GetOnAirTv getOnAirTv;
  TvOnAirProvider({required this.getOnAirTv});

  String _message = '';
  String get message => _message;

  RequestState _state = RequestState.initial;
  RequestState get state => _state;
  List<Tv> _data = <Tv>[];
  List<Tv> get data => _data;

  TvOnAirProvider init() {
    loadData();
    return this;
  }

  Future<void> loadData() async {
    _state = RequestState.loading;
    notifyListeners();

    final result = await getOnAirTv();
    result.fold(
      (failure) {
        _message = failure.message;
        _state = RequestState.error;
        notifyListeners();
      },
      (tvData) {
        if (tvData.isEmpty) {
          _state = RequestState.empty;
          _message = 'Empty TV Series';
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
