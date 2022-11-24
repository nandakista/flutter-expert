import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:submission/core/constant/network_state.dart';
import 'package:submission/core/error/failure.dart';
import 'package:submission/domain/entities/movie.dart';
import 'package:submission/domain/usecases/search_movie.dart';
import 'package:submission/ui/views/search/search_provider.dart';

import 'search_provider_test.mocks.dart';

@GenerateMocks([SearchMovie])
void main() {
  late MockSearchMovie mockSearchMovie;
  late SearchProvider provider;
  late int providerCalledCount;

  setUp(() {
    providerCalledCount = 0;
    mockSearchMovie = MockSearchMovie();
    provider = SearchProvider(searchMovie: mockSearchMovie)
      ..addListener(() => providerCalledCount += 1);
  });

  test('''Initial State and data should be empty''', () {
    expect(provider.state, NetworkState.empty);
    expect(provider.data, List<Movie>.empty());
    expect(provider.message, '');
  });

  test('''Should change state to Loading when usecase is called''', () {
    final tMovieList = <Movie>[];
    const tQuery = 'test';
    // Arrange
    when(mockSearchMovie(tQuery)).thenAnswer((_) async => Right(tMovieList));
    // Act
    provider.onSearchMovie(tQuery);
    // Assert
    expect(provider.state, NetworkState.loading);
    expect(provider.data, List<Movie>.empty());
    expect(provider.message, '');
  });

  test('''Should GET (Search) Movie data from usecase 
  and change state to Loaded''', () async {
    const tQuery = 'test';
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
    // Arrange
    when(mockSearchMovie(tQuery)).thenAnswer((_) async => Right(tMovieList));
    // Act
    await provider.onSearchMovie(tQuery);
    final result = provider.data;
    // Assert
    verify(mockSearchMovie(tQuery));
    expect(provider.state, NetworkState.loaded);
    expect(result, tMovieList);
    expect(provider.message, '');
    expect(providerCalledCount, 2);
  });

  test('''Should perform GET Search Movie data from usecase then return
  error when data is failed to load''', () async {
    const tQuery = 'test';
    // Arrange
    when(mockSearchMovie(tQuery)).thenAnswer(
          (_) async => const Left(ServerFailure('')),
    );
    // Act
    await provider.onSearchMovie(tQuery);
    // Assert
    expect(provider.state, NetworkState.error);
    expect(provider.message, '');
    expect(provider.data, List<Movie>.empty());
    expect(providerCalledCount, 2);
  });

  test('''Should perform GET Search Movie data from usecase then return
  error when failed connect to the internet''', () async {
    const tQuery = 'test';
    // Arrange
    when(mockSearchMovie(tQuery)).thenAnswer(
          (_) async => const Left(ConnectionFailure('No Internet Connection')),
    );
    // Act
    await provider.onSearchMovie(tQuery);
    // Assert
    expect(provider.state, NetworkState.error);
    expect(provider.message, 'No Internet Connection');
    expect(provider.data, List<Movie>.empty());
    expect(providerCalledCount, 2);
  });
}