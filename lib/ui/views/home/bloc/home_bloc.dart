import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:submission/domain/entities/movie.dart';
import 'package:submission/domain/usecases/get_now_playing_movies.dart';

part 'home_event.dart';

part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final GetNowPlayingMovies getNowPlayingMovies;

  HomeBloc(this.getNowPlayingMovies) : super(HomeInitial()) {
    on<LoadData>((event, emit) async {
      emit(HomeLoading());
      final result = await getNowPlayingMovies();
      result.fold(
        (failure) => emit(HomeError(failure.message)),
        (data) => emit(HomeHasData(data)),
      );
    });
  }
}
