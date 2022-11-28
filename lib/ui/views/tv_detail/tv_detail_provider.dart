import 'package:flutter/cupertino.dart';
import 'package:submission/core/constant/network_state.dart';
import 'package:submission/domain/entities/tv.dart';
import 'package:submission/domain/entities/tv_detail.dart';
import 'package:submission/domain/usecases/get_detail_tv.dart';
import 'package:submission/domain/usecases/get_recommended_tv.dart';
import 'package:submission/domain/usecases/get_watchlist_tv_exist_status.dart';
import 'package:submission/domain/usecases/remove_watchlist_tv.dart';
import 'package:submission/domain/usecases/save_watchlist_tv.dart';

class TvDetailProvider extends ChangeNotifier {
  final GetDetailTv getDetailTv;
  final GetRecommendedTv getRecommendationsTv;
  final GetWatchlistTvExistStatus getWatchlistExist;
  final SaveWatchlistTv saveWatchlist;
  final RemoveWatchlistTv removeWatchlist;

  TvDetailProvider({
    required this.getDetailTv,
    required this.getRecommendationsTv,
    required this.getWatchlistExist,
    required this.saveWatchlist,
    required this.removeWatchlist,
  });

  String _message = '';
  String get message => _message;

  RequestState _detailState = RequestState.initial;
  RequestState get detailState => _detailState;
  late TvDetail _detailTv;
  TvDetail get detailTv => _detailTv;

  RequestState _recommendedState = RequestState.initial;
  RequestState get recommendationState => _recommendedState;
  List<Tv> _recommendedTv = [];
  List<Tv> get recommendedTv => _recommendedTv;

  Future<void> loadTvDetail(int id) async {
    _detailState = RequestState.loading;
    notifyListeners();

    final detailResult = await getDetailTv(id);
    detailResult.fold(
      (failure) {
        _detailState = RequestState.error;
        _message = failure.message;
        notifyListeners();
      },
      (tv) {
        _detailTv = tv;
        _detailState = RequestState.success;
        notifyListeners();
      },
    );
  }

  Future<void> loadRecommendedTv(int id) async {
    _recommendedState = RequestState.loading;
    notifyListeners();

    final recommendationResult = await getRecommendationsTv(id);
    recommendationResult.fold(
      (failure) {
        _message = failure.message;
        _recommendedState = RequestState.error;
        notifyListeners();
      },
      (tv) {
        if (tv.isEmpty) {
          _message = 'No Recommendations Found';
          _recommendedState = RequestState.empty;
          notifyListeners();
        } else {
          _recommendedTv = tv;
          _recommendedState = RequestState.success;
          notifyListeners();
        }
      },
    );
  }

  String _watchlistMessage = '';
  String get watchlistMessage => _watchlistMessage;

  bool _hasAddedToWatchlist = false;
  bool get hasAddedToWatchlist => _hasAddedToWatchlist;

  Future<void> addWatchlist(TvDetail tv) async {
    final result = await saveWatchlist(tv);
    await result.fold(
      (failure) async {
        _watchlistMessage = failure.message;
      },
      (message) async {
        _watchlistMessage = message;
      },
    );
    await loadWatchlistExistStatus(tv.id!);
  }

  Future<void> removeFromWatchlist(TvDetail tv) async {
    final result = await removeWatchlist(tv);
    await result.fold(
      (failure) async {
        _watchlistMessage = failure.message;
      },
      (message) async {
        _watchlistMessage = message;
      },
    );
    await loadWatchlistExistStatus(tv.id!);
  }

  Future<void> loadWatchlistExistStatus(int id) async {
    _hasAddedToWatchlist = await getWatchlistExist(id);
    notifyListeners();
  }
}
