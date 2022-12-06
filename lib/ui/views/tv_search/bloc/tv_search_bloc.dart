import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:submission/core/event_transformer.dart';
import 'package:submission/domain/entities/tv.dart';
import 'package:submission/domain/usecases/search_tv.dart';

part 'tv_search_event.dart';

part 'tv_search_state.dart';

class TvSearchBloc extends Bloc<TvSearchEvent, TvSearchState> {
  final SearchTv _searchTv;

  TvSearchBloc(this._searchTv) : super(TvSearchInitial()) {
    on<OnQueryChanged>(
      (event, emit) async {
        if (event.query.isEmpty) {
          emit(TvSearchInitial());
        } else {
          final query = event.query;

          emit(TvSearchLoading());
          final result = await _searchTv(query);

          result.fold(
            (failure) {
              emit(TvSearchError(failure.message));
            },
            (data) {
              if (data.isEmpty) {
                emit(
                  const TvSearchEmpty(
                      'Oops we could not find what you were looking for!'),
                );
              } else {
                emit(TvSearchHasData(data));
              }
            },
          );
        }
      },
      transformer: debounce(const Duration(milliseconds: 500)),
    );
  }
}
