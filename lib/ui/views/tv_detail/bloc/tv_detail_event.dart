part of 'tv_detail_bloc.dart';

abstract class TvDetailEvent extends Equatable {
  const TvDetailEvent();

  @override
  List<Object> get props => [];
}

class LoadDetailTv extends TvDetailEvent {
  final int id;
  const LoadDetailTv(this.id);
}

class AddWatchlist extends TvDetailEvent {
  final TvDetail tv;
  final List<Tv> recommendation;
  const AddWatchlist(this.tv, this.recommendation);
}

class RemoveFromWatchlist extends TvDetailEvent {
  final TvDetail movie;
  final List<Tv> recommendation;
  const RemoveFromWatchlist(this.movie, this.recommendation);
}
