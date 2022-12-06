import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:submission/core/error/failure.dart';
import 'package:submission/domain/entities/movie.dart';
import 'package:submission/domain/usecases/get_now_playing_movies.dart';
import 'package:submission/ui/views/home/bloc/home_bloc.dart';

import 'home_bloc_test.mocks.dart';

@GenerateMocks([GetNowPlayingMovies])
void main() {
  late HomeBloc homeBloc;
  late MockGetNowPlayingMovies mockGetNowPlayingMovies;

  setUp(() {
    mockGetNowPlayingMovies = MockGetNowPlayingMovies();
    homeBloc = HomeBloc(mockGetNowPlayingMovies);
  });

  const tMovieList = [
    Movie(
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
    )
  ];

  test('initial state should be empty', () {
    expect(homeBloc.state, HomeInitial());
  });

  blocTest<HomeBloc, HomeState>(
    'Should emit [Loading, HasData] when data is gotten successfully',
    build: () {
      when(mockGetNowPlayingMovies())
          .thenAnswer((_) async => const Right(tMovieList));
      return homeBloc;
    },
    act: (bloc) => bloc.add(LoadData()),
    wait: const Duration(milliseconds: 500),
    expect: () => [
      HomeLoading(),
      const HomeHasData(tMovieList),
    ],
    verify: (bloc) {
      verify(mockGetNowPlayingMovies());
    },
  );

  blocTest<HomeBloc, HomeState>(
    'Should emit [Loading, Error] when get search is unsuccessful',
    build: () {
      when(mockGetNowPlayingMovies())
          .thenAnswer((_) async => const Left(ServerFailure('Server Failure')));
      return homeBloc;
    },
    act: (bloc) => bloc.add(LoadData()),
    wait: const Duration(milliseconds: 500),
    expect: () => [
      HomeLoading(),
      const HomeError('Server Failure'),
    ],
    verify: (bloc) {
      verify(mockGetNowPlayingMovies());
    },
  );

  blocTest<HomeBloc, HomeState>(
    'Should emit [Loading, Error] when no internet connection',
    build: () {
      when(mockGetNowPlayingMovies())
          .thenAnswer((_) async => const Left(ConnectionFailure('No Internet Connection')));
      return homeBloc;
    },
    act: (bloc) => bloc.add(LoadData()),
    wait: const Duration(milliseconds: 500),
    expect: () => [
      HomeLoading(),
      const HomeError('No Internet Connection'),
    ],
    verify: (bloc) {
      verify(mockGetNowPlayingMovies());
    },
  );
}
