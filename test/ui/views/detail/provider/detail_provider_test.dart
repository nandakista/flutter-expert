import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:submission/core/constant/network_state.dart';
import 'package:submission/core/error/failure.dart';
import 'package:submission/domain/entities/genre.dart';
import 'package:submission/domain/entities/movie.dart';
import 'package:submission/domain/entities/movie_detail.dart';
import 'package:submission/domain/usecases/get_detail_movie.dart';
import 'package:submission/domain/usecases/get_recommended_movies.dart';
import 'package:submission/ui/views/detail/detail_provider.dart';

import 'detail_provider_test.mocks.dart';

@GenerateMocks([GetDetailMovie, GetRecommendedMovies])
void main() {
  late MockGetDetailMovie mockGetDetailMovie;
  late MockGetRecommendedMovies mockGetRecommendedMovies;
  late DetailProvider provider;
  late int providerCalledCount;

  setUp(() {
    providerCalledCount = 0;
    mockGetDetailMovie = MockGetDetailMovie();
    mockGetRecommendedMovies = MockGetRecommendedMovies();
    provider = DetailProvider(
      getDetailMovie: mockGetDetailMovie,
      getRecommendationsMovies: mockGetRecommendedMovies,
    )..addListener(() => providerCalledCount += 1);
  });

  test('''Initial State and data should be empty''', () {
    expect(provider.detailState, NetworkState.initial);
    expect(provider.recommendationState, NetworkState.initial);
    expect(provider.recommendedMovies, List<Movie>.empty());
    expect(provider.message, '');
  });

  group('''Detail Movie''', () {
    const tMovieId = 436270;
    const tMovieDetail = MovieDetail(
      adult: false,
      backdropPath: '/bQXAqRx2Fgc46uCVWgoPz5L5Dtr.jpg',
      genres: [
        Genre(id: 28, name: 'Action'),
      ],
      homepage: 'https://www.dc.com/BlackAdam',
      id: 436270,
      originalTitle: 'Black Adam',
      overview: 'Some Overview',
      posterPath: '/pFlaoHTZeyNkG83vxsAJiGzfSsa.jpg',
      releaseDate: '2022-10-19',
      runtime: 125,
      title: 'Black Adam',
      voteAverage: 6.8,
      voteCount: 1284,
      budget: 200000000,
      imdbId: 'tt6443346',
      originalLanguage: '',
      popularity: 23828.993,
      revenue: 351000000,
      status: 'Released',
      tagline: 'The world needed a hero. It got Black Adam.',
      video: false,
    );

    test('''Should change state to Loading when usecase is called''', () {
      // Arrange
      when(mockGetDetailMovie(tMovieId)).thenAnswer(
        (_) async => const Right(tMovieDetail),
      );
      // Act
      provider.loadMovieDetail(tMovieId);
      // Assert
      expect(provider.detailState, NetworkState.loading);
      expect(provider.message, '');
    });

    test('''Should GET Detail Movie data from usecase 
    and change state to Loaded''', () async {
      // Arrange
      when(mockGetDetailMovie(tMovieId))
          .thenAnswer((_) async => const Right(tMovieDetail));
      // Act
      await provider.loadMovieDetail(tMovieId);
      final result = provider.detailMovie;
      // Assert
      verify(mockGetDetailMovie(tMovieId));
      expect(provider.detailState, NetworkState.loaded);
      expect(result, tMovieDetail);
      expect(provider.message, '');
      expect(providerCalledCount, 2);
    });

    test('''Should perform GET Detail Movie data from usecase then return
    error when data is failed to load''', () async {
      // Arrange
      when(mockGetDetailMovie(tMovieId)).thenAnswer(
        (_) async => const Left(ServerFailure('')),
      );
      // Act
      await provider.loadMovieDetail(tMovieId);
      // Assert
      expect(provider.detailState, NetworkState.error);
      expect(provider.message, '');
      expect(providerCalledCount, 2);
    });

    test('''Should perform GET Detail Movie data from usecase then return
    error when failed connect to the internet''', () async {
      // Arrange
      when(mockGetDetailMovie(tMovieId)).thenAnswer(
        (_) async => const Left(ConnectionFailure('No Internet Connection')),
      );
      // Act
      await provider.loadMovieDetail(tMovieId);
      // Assert
      expect(provider.detailState, NetworkState.error);
      expect(provider.message, 'No Internet Connection');
      expect(providerCalledCount, 2);
    });
  });

  group('''Recommended Movie''', () {
    const tMovieId = 436270;
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

    test('''Should change state to Loading when usecase is called''', () {
      // Arrange
      when(mockGetRecommendedMovies(tMovieId))
          .thenAnswer((_) async => Right(tMovieList));
      // Act
      provider.loadRecommendedMovie(tMovieId);
      // Assert
      expect(provider.recommendationState, NetworkState.loading);
      expect(provider.recommendedMovies, List<Movie>.empty());
      expect(provider.message, '');
    });

    test('''Should GET Recommended Movie data from usecase and data is not empty
    then change state to Loaded''', () async {
      // Arrange
      when(mockGetRecommendedMovies(tMovieId))
          .thenAnswer((_) async => Right(tMovieList));
      // Act
      await provider.loadRecommendedMovie(tMovieId);
      final result = provider.recommendedMovies;
      // Assert
      verify(mockGetRecommendedMovies(tMovieId));
      assert(result.isNotEmpty);
      expect(provider.recommendationState, NetworkState.loaded);
      expect(result, tMovieList);
      expect(provider.message, '');
      expect(providerCalledCount, 2);
    });

    test('''Should GET Recommended Movie data from usecase and data is empty
  then change state to Empty''', () async {
      final tMovieList = <Movie>[];
      // Arrange
      when(mockGetRecommendedMovies(tMovieId))
          .thenAnswer((_) async => Right(tMovieList));
      // Act
      await provider.loadRecommendedMovie(tMovieId);
      final result = provider.recommendedMovies;
      // Assert
      verify(mockGetRecommendedMovies(tMovieId));
      assert(result.isEmpty);
      expect(provider.recommendationState, NetworkState.empty);
      expect(result, tMovieList);
      expect(provider.message, 'No Recommendations Found');
      expect(providerCalledCount, 2);
    });

    test('''Should perform GET Recommended Movie data from usecase then return
    error when data is failed to load''', () async {
      // Arrange
      when(mockGetRecommendedMovies(tMovieId)).thenAnswer(
        (_) async => const Left(ServerFailure('')),
      );
      // Act
      await provider.loadRecommendedMovie(tMovieId);
      // Assert
      expect(provider.recommendationState, NetworkState.error);
      expect(provider.message, '');
      expect(provider.recommendedMovies, List<Movie>.empty());
      expect(providerCalledCount, 2);
    });

    test('''Should perform GET Recommended Movie data from usecase then return
    error when failed connect to the internet''', () async {
      // Arrange
      when(mockGetRecommendedMovies(tMovieId)).thenAnswer(
        (_) async => const Left(ConnectionFailure('No Internet Connection')),
      );
      // Act
      await provider.loadRecommendedMovie(tMovieId);
      // Assert
      expect(provider.recommendationState, NetworkState.error);
      expect(provider.message, 'No Internet Connection');
      expect(provider.recommendedMovies, List<Movie>.empty());
      expect(providerCalledCount, 2);
    });
  });
}
