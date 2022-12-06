import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:submission/core/event_transformer.dart';
import 'package:submission/domain/entities/movie.dart';
import 'package:submission/domain/usecases/search_movie.dart';

part 'search_event.dart';

part 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final SearchMovie _searchMovies;

  SearchBloc(this._searchMovies) : super(SearchInitial()) {
    on<OnQueryChanged>(
      (event, emit) async {
        if (event.query.isEmpty) {
          emit(SearchInitial());
        } else {
          final query = event.query;

          emit(SearchLoading());
          final result = await _searchMovies(query);

          result.fold(
            (failure) {
              emit(SearchError(failure.message));
            },
            (data) {
              if (data.isEmpty) {
                emit(
                  const SearchEmpty(
                      'Oops we could not find what you were looking for!'),
                );
              } else {
                emit(SearchHasData(data));
              }
            },
          );
        }
      },
      transformer: debounce(const Duration(milliseconds: 500)),
    );
  }
}
