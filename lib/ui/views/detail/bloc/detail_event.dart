part of 'detail_bloc.dart';

abstract class DetailEvent extends Equatable {
  const DetailEvent();

  @override
  List<Object> get props => [];
}

class LoadDetailMovies extends DetailEvent {
  final int id;
  const LoadDetailMovies(this.id);
}

class AddWatchlist extends DetailEvent {
  final MovieDetail movie;
  final List<Movie> recommendation;
  const AddWatchlist(this.movie, this.recommendation);
}

class RemoveFromWatchlist extends DetailEvent {
  final MovieDetail movie;
  final List<Movie> recommendation;
  const RemoveFromWatchlist(this.movie, this.recommendation);
}
