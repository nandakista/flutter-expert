part of 'tv_top_rated_bloc.dart';

abstract class TopRatedEvent extends Equatable {
  const TopRatedEvent();

  @override
  List<Object> get props => [];
}

class LoadTopRatedTv extends TopRatedEvent {}