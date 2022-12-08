import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:submission/core/error/failure.dart';
import 'package:submission/domain/entities/tv.dart';
import 'package:submission/domain/usecases/get_watchlist_tv.dart';
import 'package:submission/ui/views/watchlist/tv/bloc/watchlist_tv_bloc.dart';

import 'tv_watchlist_bloc_test.mocks.dart';

@GenerateMocks([GetWatchlistTv])
void main() {
  late MockGetWatchlistTv mockGetWatchlistTv;
  late WatchlistTvBloc bloc;

  setUp(() {
    mockGetWatchlistTv = MockGetWatchlistTv();
    bloc = WatchlistTvBloc(mockGetWatchlistTv);
  });

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

  test('Initial state', () {
    expect(bloc.state, WatchlistTvInitial());
  });

  blocTest<WatchlistTvBloc, WatchlistTvState>(
    'Should emit [Loading, HasData] when successfully get watchlist tv',
    build: () {
      when(mockGetWatchlistTv()).thenAnswer((_) async => Right(tTvList));
      return bloc;
    },
    act: (bloc) => bloc.add(LoadWatchlistTv()),
    wait: const Duration(milliseconds: 500),
    expect: () => [
      WatchlistTvLoading(),
      WatchlistTvHasData(tTvList),
    ],
    verify: (bloc) {
      verify(mockGetWatchlistTv());
    },
  );

  blocTest<WatchlistTvBloc, WatchlistTvState>(
    'Should emit [Loading, Empty] when failed get Watchlist Tv',
    build: () {
      when(mockGetWatchlistTv())
          .thenAnswer((_) async => const Left(DatabaseFailure('Db Failure')));
      return bloc;
    },
    act: (bloc) => bloc.add(LoadWatchlistTv()),
    wait: const Duration(milliseconds: 500),
    expect: () => [
      WatchlistTvLoading(),
      const WatchlistTvError('Db Failure'),
    ],
    verify: (bloc) {
      verify(mockGetWatchlistTv());
    },
  );

  blocTest<WatchlistTvBloc, WatchlistTvState>(
    'Should emit [Loading, Empty] when no one tv in Watchlist',
    build: () {
      when(mockGetWatchlistTv()).thenAnswer((_) async => const Right([]));
      return bloc;
    },
    act: (bloc) => bloc.add(LoadWatchlistTv()),
    wait: const Duration(milliseconds: 500),
    expect: () => [
      WatchlistTvLoading(),
      const WatchlistTvEmpty('Empty Tv Watchlist'),
    ],
    verify: (bloc) {
      verify(mockGetWatchlistTv());
    },
  );
}
