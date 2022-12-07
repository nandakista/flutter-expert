import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:submission/core/error/failure.dart';
import 'package:submission/domain/entities/movie.dart';
import 'package:submission/domain/usecases/get_top_rated_movies.dart';
import 'package:submission/ui/views/top_rated/bloc/top_rated_bloc.dart';

import 'top_rated_bloc_test.mocks.dart';

@GenerateMocks([GetTopRatedMovies])
void main() {
  late MockGetTopRatedMovies mockGetTopRatedMovies;
  late TopRatedBloc topRatedBloc;

  setUp(() {
    mockGetTopRatedMovies = MockGetTopRatedMovies();
    topRatedBloc = TopRatedBloc(mockGetTopRatedMovies);
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

  test('Verify Initial state', () {
    expect(topRatedBloc.state, TopRatedInitial());
  });

  blocTest<TopRatedBloc, TopRatedState>(
    'Should emit [Loading, HasData] when successfully get data',
    build: () {
      when(mockGetTopRatedMovies())
          .thenAnswer((_) async => Right(tMovieList));
      return topRatedBloc;
    },
    act: (bloc) => bloc.add(LoadTopRatedMovies()),
    wait: const Duration(milliseconds: 500),
    expect: () => [
      TopRatedLoading(),
      TopRatedHasData(tMovieList),
    ],
    verify: (bloc) {
      verify(mockGetTopRatedMovies());
    },
  );

  blocTest<TopRatedBloc, TopRatedState>(
    'Should emit [Loading, Error] when failed get data',
    build: () {
      when(mockGetTopRatedMovies())
          .thenAnswer((_) async => const Left(ServerFailure('Server Failure')));
      return topRatedBloc;
    },
    act: (bloc) => bloc.add(LoadTopRatedMovies()),
    wait: const Duration(milliseconds: 500),
    expect: () => [
      TopRatedLoading(),
      const TopRatedError('Server Failure'),
    ],
    verify: (bloc) {
      verify(mockGetTopRatedMovies());
    },
  );

  blocTest<TopRatedBloc, TopRatedState>(
    'Should emit [Loading, Error] when no internet connection',
    build: () {
      when(mockGetTopRatedMovies())
          .thenAnswer((_) async => const Left(ConnectionFailure('No Internet Connection')));
      return topRatedBloc;
    },
    act: (bloc) => bloc.add(LoadTopRatedMovies()),
    wait: const Duration(milliseconds: 500),
    expect: () => [
      TopRatedLoading(),
      const TopRatedError('No Internet Connection'),
    ],
    verify: (bloc) {
      verify(mockGetTopRatedMovies());
    },
  );
}