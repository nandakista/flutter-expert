import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:submission/domain/entities/tv.dart';
import 'package:submission/domain/usecases/get_watchlist_tv.dart';

part 'watchlist_tv_event.dart';

part 'watchlist_tv_state.dart';

class WatchlistTvBloc
    extends Bloc<WatchlistTvEvent, WatchlistTvState> {
  final GetWatchlistTv getWatchlist;

  WatchlistTvBloc(this.getWatchlist) : super(WatchlistTvInitial()) {
    on<LoadWatchlistTv>((event, emit) async {
      emit(WatchlistTvLoading());
      final result = await getWatchlist();
      result.fold(
        (failure) => emit(WatchlistTvError(failure.message)),
        (data) {
          if(data.isEmpty) {
            emit(const WatchlistTvEmpty('Empty Tv Watchlist'));
          } else {
            emit(WatchlistTvHasData(data));
          }
        },
      );
    });
  }
}
