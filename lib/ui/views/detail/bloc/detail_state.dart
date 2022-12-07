part of 'detail_bloc.dart';

abstract class DetailState extends Equatable {
  const DetailState();

  @override
  List<Object> get props => [];
}

class DetailInitial extends DetailState {}

class DetailLoading extends DetailState {}

class DetailError extends DetailState {
  final String message;

  const DetailError(this.message);

  @override
  List<Object> get props => [message];
}

class DetailHasData extends DetailState {
  final MovieDetail detail;
  final List<Movie> recommendedMovie;
  final String message;
  final String watchlistMessage;
  final bool hasAddedToWatchList;

  const DetailHasData({
    required this.detail,
    this.message = '',
    this.recommendedMovie = const [],
    this.watchlistMessage = '',
    this.hasAddedToWatchList = false,
  });

  @override
  List<Object> get props => [
        detail,
        recommendedMovie,
        message,
        watchlistMessage,
        hasAddedToWatchList,
      ];
}
