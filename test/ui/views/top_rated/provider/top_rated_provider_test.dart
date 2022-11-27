import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:submission/core/constant/network_state.dart';
import 'package:submission/core/error/failure.dart';
import 'package:submission/domain/entities/movie.dart';
import 'package:submission/domain/usecases/get_top_rated_movies.dart';
import 'package:submission/ui/views/top_rated/top_rated_provider.dart';

import 'top_rated_provider_test.mocks.dart';

@GenerateMocks([GetTopRatedMovies])
void main() {
  late MockGetTopRatedMovies mockGetTopRatedMovies;
  late TopRatedProvider provider;
  late int providerCalledCount;

  setUp(() {
    providerCalledCount = 0;
    mockGetTopRatedMovies = MockGetTopRatedMovies();
    provider = TopRatedProvider(getTopRatedMovies: mockGetTopRatedMovies)
      ..addListener(() => providerCalledCount += 1);
  });

  test('''Initial State and data should be empty''', () {
    expect(provider.state, RequestState.initial);
    expect(provider.data, List<Movie>.empty());
    expect(provider.message, '');
  });

  test('''Should change state to Loading when usecase is called''', () {
    final tMovieList = <Movie>[];
    // Arrange
    when(mockGetTopRatedMovies()).thenAnswer((_) async => Right(tMovieList));
    // Act
    provider.loadData();
    // Assert
    expect(provider.state, RequestState.loading);
    expect(provider.data, List<Movie>.empty());
    expect(provider.message, '');
  });

  test('''Should GET Top Rated Movie data from usecase and data is not empty
  then change state to Loaded''', () async {
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
    when(mockGetTopRatedMovies()).thenAnswer((_) async => Right(tMovieList));
    // Act
    await provider.loadData();
    final result = provider.data;
    // Assert
    verify(mockGetTopRatedMovies());
    assert(result.isNotEmpty);
    expect(provider.state, RequestState.success);
    expect(result, tMovieList);
    expect(providerCalledCount, 2);
  });

  test('''Should GET Top Rated Movie data from usecase and data is empty
  then change state to Empty''', () async {
    final tMovieList = <Movie>[];
    // Arrange
    when(mockGetTopRatedMovies()).thenAnswer((_) async => Right(tMovieList));
    // Act
    await provider.loadData();
    final result = provider.data;
    // Assert
    verify(mockGetTopRatedMovies());
    assert(result.isEmpty);
    expect(provider.state, RequestState.empty);
    expect(provider.message, 'Empty Top Rated Movies');
    expect(result, tMovieList);
    expect(providerCalledCount, 2);
  });

  test('''Should perform GET Top Rated Movie data from usecase then return
  error when data is failed to load''', () async {
    // Arrange
    when(mockGetTopRatedMovies()).thenAnswer(
      (_) async => const Left(ServerFailure('')),
    );
    // Act
    await provider.loadData();
    // Assert
    expect(provider.state, RequestState.error);
    expect(provider.message, '');
    expect(provider.data, List<Movie>.empty());
    expect(providerCalledCount, 2);
  });

  test('''Should perform GET Top Rated Movie data from usecase then return
  error when failed connect to the internet''', () async {
    // Arrange
    when(mockGetTopRatedMovies()).thenAnswer(
      (_) async => const Left(ConnectionFailure('No Internet Connection')),
    );
    // Act
    await provider.loadData();
    // Assert
    expect(provider.state, RequestState.error);
    expect(provider.message, 'No Internet Connection');
    expect(provider.data, List<Movie>.empty());
    expect(providerCalledCount, 2);
  });
}
