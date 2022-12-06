part of 'tv_on_air_bloc.dart';

abstract class TvOnAirState extends Equatable {
  const TvOnAirState();

  @override
  List<Object> get props => [];
}

class TvOnAirInitial extends TvOnAirState {}

class TvOnAirLoading extends TvOnAirState {}

class TvOnAirError extends TvOnAirState {
  final String message;

  const TvOnAirError(this.message);

  @override
  List<Object> get props => [message];
}

class TvOnAirHasData extends TvOnAirState {
  final List<Tv> result;

  const TvOnAirHasData(this.result);

  @override
  List<Object> get props => [result];
}