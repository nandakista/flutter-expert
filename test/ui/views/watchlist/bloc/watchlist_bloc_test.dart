import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:submission/core/error/failure.dart';
import 'package:submission/domain/entities/movie.dart';
import 'package:submission/domain/usecases/get_watchlist_movie.dart';
import 'package:submission/ui/views/watchlist/movie/bloc/watchlist_movie_bloc.dart';

import 'watchlist_bloc_test.mocks.dart';

@GenerateMocks([GetWatchlistMovie])
void main() {
  late MockGetWatchlistMovie mockGetWatchlistMovie;
  late WatchlistMovieBloc bloc;

  setUp(() {
    mockGetWatchlistMovie = MockGetWatchlistMovie();
    bloc = WatchlistMovieBloc(mockGetWatchlistMovie);
  });

  final tMovieList = [
    const Movie(
      adult: false,
      backdropPath: '/url.jpg',
      genreIds: [
        28,
        14,
        878,
      ],
      id: 436270,
      originalTitle: 'Black Adam',
      overview: 'Some Overview',
      popularity: 23828.993,
      posterPath: '/url.jpg',
      releaseDate: '2022-10-19',
      title: 'Black Adam',
      video: false,
      voteAverage: 6.8,
      voteCount: 1270,
    ),
  ];

  test('Initial state', () {
    expect(bloc.state, WatchlistMovieInitial());
  });

  blocTest<WatchlistMovieBloc, WatchlistMovieState>(
    'Should emit [Loading, HasData] when successfully get watchlist movie',
    build: () {
      when(mockGetWatchlistMovie())
          .thenAnswer((_) async => Right(tMovieList));
      return bloc;
    },
    act: (bloc) => bloc.add(LoadWatchlistMovie()),
    wait: const Duration(milliseconds: 500),
    expect: () => [
      WatchlistMovieLoading(),
      WatchlistMovieHasData(tMovieList),
    ],
    verify: (bloc) {
      verify(mockGetWatchlistMovie());
    },
  );

  blocTest<WatchlistMovieBloc, WatchlistMovieState>(
    'Should emit [Loading, Empty] when failed get Watchlist Movie',
    build: () {
      when(mockGetWatchlistMovie())
          .thenAnswer((_) async => const Left(DatabaseFailure('Db Failure')));
      return bloc;
    },
    act: (bloc) => bloc.add(LoadWatchlistMovie()),
    wait: const Duration(milliseconds: 500),
    expect: () => [
      WatchlistMovieLoading(),
      const WatchlistMovieError('Db Failure'),
    ],
    verify: (bloc) {
      verify(mockGetWatchlistMovie());
    },
  );

  blocTest<WatchlistMovieBloc, WatchlistMovieState>(
    'Should emit [Loading, Empty] when no one movie in Watchlist',
    build: () {
      when(mockGetWatchlistMovie())
          .thenAnswer((_) async => const Right([]));
      return bloc;
    },
    act: (bloc) => bloc.add(LoadWatchlistMovie()),
    wait: const Duration(milliseconds: 500),
    expect: () => [
      WatchlistMovieLoading(),
      const WatchlistMovieEmpty('Empty Movie Watchlist'),
    ],
    verify: (bloc) {
      verify(mockGetWatchlistMovie());
    },
  );
}