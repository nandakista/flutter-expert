import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:submission/core/error/failure.dart';
import 'package:submission/domain/entities/movie.dart';
import 'package:submission/domain/usecases/search_movie.dart';
import 'package:submission/ui/views/search/bloc/search_bloc.dart';

import 'search_bloc_test.mocks.dart';

@GenerateMocks([SearchMovie])
void main() {
  late SearchBloc searchBloc;
  late MockSearchMovie mockSearchMovies;

  setUp(() {
    mockSearchMovies = MockSearchMovie();
    searchBloc = SearchBloc(mockSearchMovies);
  });

  const tMovieModel = Movie(
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
  );
  final tMovieList = <Movie>[tMovieModel];
  const tQuery = 'black adam';

  test('initial state should be empty', () {
    expect(searchBloc.state, SearchInitial());
  });

  blocTest<SearchBloc, SearchState>(
    'Should emit [Loading, HasData] when data is gotten successfully',
    build: () {
      when(mockSearchMovies(tQuery)).thenAnswer((_) async => Right(tMovieList));
      return searchBloc;
    },
    act: (bloc) => bloc.add(const OnQueryChanged(tQuery)),
    wait: const Duration(milliseconds: 500),
    expect: () => [
      SearchLoading(),
      SearchHasData(tMovieList),
    ],
    verify: (bloc) {
      verify(mockSearchMovies(tQuery));
    },
  );

  blocTest<SearchBloc, SearchState>(
    'Should emit [Loading, Error] when get search is unsuccessful',
    build: () {
      when(mockSearchMovies(tQuery))
          .thenAnswer((_) async => const Left(ServerFailure('Server Failure')));
      return searchBloc;
    },
    act: (bloc) => bloc.add(const OnQueryChanged(tQuery)),
    wait: const Duration(milliseconds: 500),
    expect: () => [
      SearchLoading(),
      const SearchError('Server Failure'),
    ],
    verify: (bloc) {
      verify(mockSearchMovies(tQuery));
    },
  );
}
