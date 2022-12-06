part of 'tv_on_air_bloc.dart';

abstract class TvOnAirEvent extends Equatable {
  const TvOnAirEvent();

  @override
  List<Object> get props => [];
}

class LoadOnAirTv extends TvOnAirEvent {}