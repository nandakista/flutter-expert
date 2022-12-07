import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:submission/core/error/failure.dart';
import 'package:submission/domain/entities/movie.dart';
import 'package:submission/domain/usecases/get_popular_movies.dart';
import 'package:submission/ui/views/popular/bloc/popular_bloc.dart';

import 'popular_bloc_test.mocks.dart';

@GenerateMocks([GetPopularMovies])
void main() {
  late PopularBloc popularBloc;
  late MockGetPopularMovies mockGetPopularMovies;

  setUp(() {
    mockGetPopularMovies = MockGetPopularMovies();
    popularBloc = PopularBloc(mockGetPopularMovies);
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

  test('Initial state should be empty', () {
    expect(popularBloc.state, PopularInitial());
  });

  blocTest<PopularBloc, PopularState>(
    'Should emit [Loading, HasData] when successfully get data',
    build: () {
      when(mockGetPopularMovies())
          .thenAnswer((_) async => Right(tMovieList));
      return popularBloc;
    },
    act: (bloc) => bloc.add(LoadPopularMovies()),
    wait: const Duration(milliseconds: 500),
    expect: () => [
      PopularLoading(),
      PopularHasData(tMovieList),
    ],
    verify: (bloc) {
      verify(mockGetPopularMovies());
    },
  );

  blocTest<PopularBloc, PopularState>(
    'Should emit [Loading, Error] when failed get data',
    build: () {
      when(mockGetPopularMovies())
          .thenAnswer((_) async => const Left(ServerFailure('Server Failure')));
      return popularBloc;
    },
    act: (bloc) => bloc.add(LoadPopularMovies()),
    wait: const Duration(milliseconds: 500),
    expect: () => [
      PopularLoading(),
      const PopularError('Server Failure'),
    ],
    verify: (bloc) {
      verify(mockGetPopularMovies());
    },
  );

  blocTest<PopularBloc, PopularState>(
    'Should emit [Loading, Error] when no internet connection',
    build: () {
      when(mockGetPopularMovies())
          .thenAnswer((_) async => const Left(ConnectionFailure('No Internet Connection')));
      return popularBloc;
    },
    act: (bloc) => bloc.add(LoadPopularMovies()),
    wait: const Duration(milliseconds: 500),
    expect: () => [
      PopularLoading(),
      const PopularError('No Internet Connection'),
    ],
    verify: (bloc) {
      verify(mockGetPopularMovies());
    },
  );
}