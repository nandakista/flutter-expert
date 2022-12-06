part of 'home_bloc.dart';

abstract class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object> get props => [];
}

class HomeInitial extends HomeState {}

class HomeLoading extends HomeState {}

class HomeError extends HomeState {
  final String message;

  const HomeError(this.message);

  @override
  List<Object> get props => [message];
}

class HomeHasData extends HomeState {
  final List<Movie> result;

  const HomeHasData(this.result);

  @override
  List<Object> get props => [result];
}