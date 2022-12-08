part of 'watchlist_tv_bloc.dart';

abstract class WatchlistTvState extends Equatable {
  const WatchlistTvState();

  @override
  List<Object> get props => [];
}

class WatchlistTvInitial extends WatchlistTvState {}

class WatchlistTvLoading extends WatchlistTvState {}

class WatchlistTvError extends WatchlistTvState {
  final String message;

  const WatchlistTvError(this.message);

  @override
  List<Object> get props => [message];
}

class WatchlistTvEmpty extends WatchlistTvState {
  final String message;

  const WatchlistTvEmpty(this.message);

  @override
  List<Object> get props => [message];
}

class WatchlistTvHasData extends WatchlistTvState {
  final List<Tv> result;

  const WatchlistTvHasData(this.result);

  @override
  List<Object> get props => [result];
}
