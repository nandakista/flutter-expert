import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:submission/domain/entities/tv.dart';
import 'package:submission/domain/entities/tv_detail.dart';
import 'package:submission/domain/usecases/get_detail_tv.dart';
import 'package:submission/domain/usecases/get_recommended_tv.dart';
import 'package:submission/domain/usecases/get_watchlist_tv_exist_status.dart';
import 'package:submission/domain/usecases/remove_watchlist_tv.dart';
import 'package:submission/domain/usecases/save_watchlist_tv.dart';

part 'tv_detail_event.dart';

part 'tv_detail_state.dart';

class TvDetailBloc extends Bloc<TvDetailEvent, TvDetailState> {
  final GetDetailTv getDetailTv;
  final GetRecommendedTv getRecommendationsTv;
  final GetWatchlistTvExistStatus getWatchlistExist;
  final SaveWatchlistTv saveWatchlist;
  final RemoveWatchlistTv removeWatchlist;

  TvDetailBloc({
    required this.getDetailTv,
    required this.getRecommendationsTv,
    required this.getWatchlistExist,
    required this.saveWatchlist,
    required this.removeWatchlist,
  }) : super(TvDetailInitial()) {
    on<LoadDetailTv>((event, emit) async {
      emit(TvDetailLoading());
      final detailResult = await getDetailTv(event.id);
      final recommendedResult = await getRecommendationsTv(event.id);
      final watchlistStatus = await getWatchlistExist(event.id);
      detailResult.fold(
        (failure) => emit(TvDetailError(failure.message)),
        (data) {
          recommendedResult.fold(
            (failure) => emit(TvDetailError(failure.message)),
            (recommended) {
              emit(TvDetailHasData(
                detail: data,
                recommendedTv: recommended,
                hasAddedToWatchList: watchlistStatus,
              ));
            },
          );
        },
      );
    });

    on<AddWatchlist>((event, emit) async {
      final result = await saveWatchlist(event.tv);
      await result.fold(
        (failure) async {
          emit(
            TvDetailHasData(
              detail: event.tv,
              recommendedTv: event.recommendation,
              watchlistMessage: failure.message,
              hasAddedToWatchList: false,
            ),
          );
        },
        (message) async {
          emit(
            TvDetailHasData(
              detail: event.tv,
              recommendedTv: event.recommendation,
              watchlistMessage: message,
              hasAddedToWatchList: true,
            ),
          );
        },
      );
    });

    on<RemoveFromWatchlist>((event, emit) async {
      final result = await removeWatchlist(event.movie);
      await result.fold(
        (failure) async {
          emit(
            TvDetailHasData(
              detail: event.movie,
              recommendedTv: event.recommendation,
              watchlistMessage: failure.message,
              hasAddedToWatchList: true,
            ),
          );
        },
        (message) async {
          emit(
            TvDetailHasData(
              detail: event.movie,
              recommendedTv: event.recommendation,
              watchlistMessage: message,
              hasAddedToWatchList: false,
            ),
          );
        },
      );
    });
  }
}
