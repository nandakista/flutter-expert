part of 'tv_detail_bloc.dart';

abstract class TvDetailState extends Equatable {
  const TvDetailState();

  @override
  List<Object> get props => [];
}

class TvDetailInitial extends TvDetailState {}

class TvDetailLoading extends TvDetailState {}

class TvDetailError extends TvDetailState {
  final String message;

  const TvDetailError(this.message);

  @override
  List<Object> get props => [message];
}

class TvDetailHasData extends TvDetailState {
  final TvDetail detail;
  final List<Tv> recommendedTv;
  final String message;
  final String watchlistMessage;
  final bool hasAddedToWatchList;

  const TvDetailHasData({
    required this.detail,
    this.message = '',
    this.recommendedTv = const [],
    this.watchlistMessage = '',
    this.hasAddedToWatchList = false,
  });

  @override
  List<Object> get props => [
        detail,
        recommendedTv,
        message,
        watchlistMessage,
        hasAddedToWatchList,
      ];
}
