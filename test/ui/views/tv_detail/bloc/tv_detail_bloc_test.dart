import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:submission/core/error/failure.dart';
import 'package:submission/domain/entities/genre.dart';
import 'package:submission/domain/entities/season.dart';
import 'package:submission/domain/entities/tv.dart';
import 'package:submission/domain/entities/tv_detail.dart';
import 'package:submission/domain/usecases/get_detail_tv.dart';
import 'package:submission/domain/usecases/get_recommended_tv.dart';
import 'package:submission/domain/usecases/get_watchlist_tv_exist_status.dart';
import 'package:submission/domain/usecases/remove_watchlist_tv.dart';
import 'package:submission/domain/usecases/save_watchlist_tv.dart';
import 'package:submission/ui/views/tv_detail/bloc/tv_detail_bloc.dart';

import 'tv_detail_bloc_test.mocks.dart';

@GenerateMocks([
  GetDetailTv,
  GetRecommendedTv,
  GetWatchlistTvExistStatus,
  SaveWatchlistTv,
  RemoveWatchlistTv,
])
void main() {
  late TvDetailBloc detailBloc;
  late MockGetDetailTv mockGetDetailTv;
  late MockGetRecommendedTv mockGetRecommendedTv;
  late MockGetWatchlistTvExistStatus mockGetWatchlistTvExistStatus;
  late MockSaveWatchlistTv mockSaveWatchlistTv;
  late MockRemoveWatchlistTv mockRemoveWatchlistTv;

  setUp(() {
    mockGetDetailTv = MockGetDetailTv();
    mockGetRecommendedTv = MockGetRecommendedTv();
    mockGetWatchlistTvExistStatus = MockGetWatchlistTvExistStatus();
    mockSaveWatchlistTv = MockSaveWatchlistTv();
    mockRemoveWatchlistTv = MockRemoveWatchlistTv();
    detailBloc = TvDetailBloc(
      getDetailTv: mockGetDetailTv,
      getRecommendationsTv: mockGetRecommendedTv,
      getWatchlistExist: mockGetWatchlistTvExistStatus,
      saveWatchlist: mockSaveWatchlistTv,
      removeWatchlist: mockRemoveWatchlistTv,
    );
  });

  const tTvId = 436270;
  const tTvDetail = TvDetail(
    adult: false,
    backdropPath: "/url.jpg",
    episodeRunTime: [39],
    firstAirDate: "2021-11-06",
    genres: [
      Genre(id: 16, name: "Animation"),
      Genre(id: 10765, name: "Sci-Fi & Fantasy"),
    ],
    homepage: "https://arcane.com",
    id: 94605,
    inProduction: true,
    languages: ["am", "ar", "en", "hz"],
    lastAirDate: "2021-11-20",
    name: "Arcane",
    nextEpisodeToAir: null,
    numberOfEpisodes: 9,
    numberOfSeasons: 2,
    originCountry: ["US"],
    originalLanguage: "en",
    originalName: "Arcane",
    overview: "overview",
    popularity: 95.866,
    posterPath: "/url.jpg",
    seasons: [
      Season(
          airDate: "2021-11-06",
          episodeCount: 9,
          id: 134187,
          name: "Season 1",
          overview: "",
          posterPath: "/url.jpg",
          seasonNumber: 1)
    ],
    status: "Returning Series",
    tagline: "",
    type: "Scripted",
    voteAverage: 8.746,
    voteCount: 2704,
  );

  final tTvList = [
    const Tv(
      id: 60625,
      name: 'Rick and Morty',
      posterPath: '/url.jpg',
      overview: 'overview',
      voteAverage: 8.7,
      voteCount: 7426,
      popularity: 1377.974,
      originalName: 'Rick and Morty',
      originalLanguage: 'en',
      originCountry: ['US'],
      firstAirDate: '2013-12-02',
      genreIds: [16, 35, 10765, 10759],
      backdropPath: '/url.jpg',
    ),
  ];

  test('Initial state should be empty', () {
    expect(detailBloc.state, TvDetailInitial());
  });

  blocTest<TvDetailBloc, TvDetailState>(
    'Should emit [Loading, HasData] when successfully get detail, '
    'successfully get recommended tv, and already save in watchlist '
    'so existing status watchlist is true',
    build: () {
      when(mockGetDetailTv(tTvId))
          .thenAnswer((_) async => const Right(tTvDetail));
      when(mockGetRecommendedTv(tTvId)).thenAnswer((_) async => Right(tTvList));
      when(mockGetWatchlistTvExistStatus(tTvId)).thenAnswer((_) async => true);
      return detailBloc;
    },
    act: (bloc) {
      bloc.add(const LoadDetailTv(tTvId));
    },
    wait: const Duration(milliseconds: 500),
    expect: () => [
      TvDetailLoading(),
      TvDetailHasData(
        detail: tTvDetail,
        recommendedTv: tTvList,
        hasAddedToWatchList: true,
      ),
    ],
    verify: (bloc) {
      verify(mockGetDetailTv(tTvId));
      verify(mockGetRecommendedTv(tTvId));
      verify(mockGetWatchlistTvExistStatus(tTvId));
    },
  );

  blocTest<TvDetailBloc, TvDetailState>(
    'Should emit [Loading, HasData] when successfully get detail, '
    'successfully get recommended tv, and havent save in watchlist '
    'so existing status watchlist is false',
    build: () {
      when(mockGetDetailTv(tTvId))
          .thenAnswer((_) async => const Right(tTvDetail));
      when(mockGetRecommendedTv(tTvId)).thenAnswer((_) async => Right(tTvList));
      when(mockGetWatchlistTvExistStatus(tTvId)).thenAnswer((_) async => false);
      return detailBloc;
    },
    act: (bloc) {
      bloc.add(const LoadDetailTv(tTvId));
    },
    wait: const Duration(milliseconds: 500),
    expect: () => [
      TvDetailLoading(),
      TvDetailHasData(
        detail: tTvDetail,
        recommendedTv: tTvList,
        hasAddedToWatchList: false,
      ),
    ],
    verify: (bloc) {
      verify(mockGetDetailTv(tTvId));
      verify(mockGetRecommendedTv(tTvId));
      verify(mockGetWatchlistTvExistStatus(tTvId));
    },
  );

  blocTest<TvDetailBloc, TvDetailState>(
    'when failed get detail, but successfully to get recommendation tv.'
    'Should emit [Loading, Error]',
    build: () {
      when(mockGetDetailTv(tTvId))
          .thenAnswer((_) async => const Left(ServerFailure('Server Failure')));
      when(mockGetRecommendedTv(tTvId)).thenAnswer((_) async => Right(tTvList));
      when(mockGetWatchlistTvExistStatus(tTvId)).thenAnswer((_) async => true);
      return detailBloc;
    },
    act: (bloc) {
      bloc.add(const LoadDetailTv(tTvId));
    },
    wait: const Duration(milliseconds: 500),
    expect: () => [
      TvDetailLoading(),
      const TvDetailError('Server Failure'),
    ],
    verify: (bloc) {
      verify(mockGetDetailTv(tTvId));
      verify(mockGetRecommendedTv(tTvId));
      verify(mockGetWatchlistTvExistStatus(tTvId));
    },
  );

  blocTest<TvDetailBloc, TvDetailState>(
    'Should emit [Loading, Error] when successfully get detail, '
    'existing status watchlist, but failed to get recommendation tv',
    build: () {
      when(mockGetDetailTv(tTvId))
          .thenAnswer((_) async => const Right(tTvDetail));
      when(mockGetRecommendedTv(tTvId))
          .thenAnswer((_) async => const Left(ServerFailure('Server Failure')));
      when(mockGetWatchlistTvExistStatus(tTvId)).thenAnswer((_) async => true);
      return detailBloc;
    },
    act: (bloc) {
      bloc.add(const LoadDetailTv(tTvId));
    },
    wait: const Duration(milliseconds: 500),
    expect: () => [
      TvDetailLoading(),
      const TvDetailError('Server Failure'),
    ],
    verify: (bloc) {
      verify(mockGetDetailTv(tTvId));
      verify(mockGetRecommendedTv(tTvId));
      verify(mockGetWatchlistTvExistStatus(tTvId));
    },
  );

  blocTest<TvDetailBloc, TvDetailState>(
    'when request get detail tv with no internet connection Should emit [Loading, Error]',
    build: () {
      when(mockGetDetailTv(tTvId)).thenAnswer(
          (_) async => const Left(ConnectionFailure('No Internet')));
      when(mockGetRecommendedTv(tTvId)).thenAnswer((_) async => Right(tTvList));
      when(mockGetWatchlistTvExistStatus(tTvId)).thenAnswer((_) async => true);
      return detailBloc;
    },
    act: (bloc) {
      bloc.add(const LoadDetailTv(tTvId));
    },
    wait: const Duration(milliseconds: 500),
    expect: () => [
      TvDetailLoading(),
      const TvDetailError('No Internet'),
    ],
    verify: (bloc) {
      verify(mockGetDetailTv(tTvId));
      verify(mockGetRecommendedTv(tTvId));
      verify(mockGetWatchlistTvExistStatus(tTvId));
    },
  );

  blocTest<TvDetailBloc, TvDetailState>(
    'when request get recommended tv with no internet connection Should emit [Loading, Error]',
    build: () {
      when(mockGetDetailTv(tTvId))
          .thenAnswer((_) async => const Right(tTvDetail));
      when(mockGetRecommendedTv(tTvId)).thenAnswer(
          (_) async => const Left(ConnectionFailure('No Internet')));
      when(mockGetWatchlistTvExistStatus(tTvId)).thenAnswer((_) async => true);
      return detailBloc;
    },
    act: (bloc) {
      bloc.add(const LoadDetailTv(tTvId));
    },
    wait: const Duration(milliseconds: 500),
    expect: () => [
      TvDetailLoading(),
      const TvDetailError('No Internet'),
    ],
    verify: (bloc) {
      verify(mockGetDetailTv(tTvId));
      verify(mockGetRecommendedTv(tTvId));
      verify(mockGetWatchlistTvExistStatus(tTvId));
    },
  );

  blocTest<TvDetailBloc, TvDetailState>(
    'when successfully save to watchlist Should emit [HasData] with watchlistMessage'
    'from following message from usecase and change status watchlist to true',
    build: () {
      when(mockSaveWatchlistTv(tTvDetail))
          .thenAnswer((_) async => const Right('Added to Watchlist'));
      return detailBloc;
    },
    act: (bloc) {
      bloc.add(AddWatchlist(tTvDetail, tTvList));
    },
    wait: const Duration(milliseconds: 500),
    expect: () => [
      TvDetailHasData(
        detail: tTvDetail,
        recommendedTv: tTvList,
        hasAddedToWatchList: true,
        watchlistMessage: 'Added to Watchlist',
      ),
    ],
    verify: (bloc) {
      verify(mockSaveWatchlistTv(tTvDetail));
    },
  );

  blocTest<TvDetailBloc, TvDetailState>(
    'when failed save to watchlist Should emit [HasData] with watchlistMessage'
    'from following message from usecase and status watchlist is still false',
    build: () {
      when(mockSaveWatchlistTv(tTvDetail)).thenAnswer(
          (_) async => const Left(DatabaseFailure('Failed save to watchlist')));
      return detailBloc;
    },
    act: (bloc) {
      bloc.add(AddWatchlist(tTvDetail, tTvList));
    },
    wait: const Duration(milliseconds: 500),
    expect: () => [
      TvDetailHasData(
        detail: tTvDetail,
        recommendedTv: tTvList,
        hasAddedToWatchList: false,
        watchlistMessage: 'Failed save to watchlist',
      ),
    ],
    verify: (bloc) {
      verify(mockSaveWatchlistTv(tTvDetail));
    },
  );

  blocTest<TvDetailBloc, TvDetailState>(
    'when successfully remove from watchlist Should emit [HasData] with watchlistMessage'
    'from following message from usecase and change status watchlist to false',
    build: () {
      when(mockRemoveWatchlistTv(tTvDetail))
          .thenAnswer((_) async => const Right('Remove from Watchlist'));
      return detailBloc;
    },
    act: (bloc) {
      bloc.add(RemoveFromWatchlist(tTvDetail, tTvList));
    },
    wait: const Duration(milliseconds: 500),
    expect: () => [
      TvDetailHasData(
        detail: tTvDetail,
        recommendedTv: tTvList,
        hasAddedToWatchList: false,
        watchlistMessage: 'Remove from Watchlist',
      ),
    ],
    verify: (bloc) {
      verify(mockRemoveWatchlistTv(tTvDetail));
    },
  );

  blocTest<TvDetailBloc, TvDetailState>(
    'when failed remove from watchlist Should emit [HasData] with watchlistMessage'
    'from following message from usecase and status watchlist is still true',
    build: () {
      when(mockRemoveWatchlistTv(tTvDetail)).thenAnswer(
          (_) async => const Left(DatabaseFailure('Failed remove')));
      return detailBloc;
    },
    act: (bloc) {
      bloc.add(RemoveFromWatchlist(tTvDetail, tTvList));
    },
    wait: const Duration(milliseconds: 500),
    expect: () => [
      TvDetailHasData(
        detail: tTvDetail,
        recommendedTv: tTvList,
        hasAddedToWatchList: true,
        watchlistMessage: 'Failed remove',
      ),
    ],
    verify: (bloc) {
      verify(mockRemoveWatchlistTv(tTvDetail));
    },
  );
}
