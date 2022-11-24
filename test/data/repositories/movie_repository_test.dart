import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:submission/core/error/exception.dart';
import 'package:submission/core/error/failure.dart';
import 'package:submission/data/repositories/movie_repository_impl.dart';
import 'package:submission/data/sources/server/movie_server_source.dart';
import 'package:submission/domain/entities/genre.dart';
import 'package:submission/domain/entities/movie.dart';
import 'package:submission/domain/entities/movie_detail.dart';

import 'movie_repository_test.mocks.dart';

@GenerateMocks([MovieServerSource])
void main() {
  late MovieRepositoryImpl repository;
  late MockMovieServerSource mockMovieServerSource;

  setUp(() {
    mockMovieServerSource = MockMovieServerSource();
    repository = MovieRepositoryImpl(serverSource: mockMovieServerSource);
  });

  group('''Now Playing Movie''', () {
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

    test('''Should perform getNowPlayingMovies() then return 
    MovieList when the call server source is success ''', () async {
      // Arrange
      when(mockMovieServerSource.getNowPlayingMovies())
          .thenAnswer((_) async => tMovieList);
      // Act
      final result = await repository.getNowPlayingMovies();
      // Assert
      verify(mockMovieServerSource.getNowPlayingMovies());
      expect(result, equals(Right(tMovieList)));
    });

    test('''Should perform getNowPlayingMovies() then return 
    ServerFailure when the call server source is failed ''', () async {
      // Arrange

      when(mockMovieServerSource.getNowPlayingMovies())
          .thenThrow(ServerException());
      // Act
      final result = await repository.getNowPlayingMovies();

      // Assert
      verify(mockMovieServerSource.getNowPlayingMovies());
      expect(result, equals(const Left(ServerFailure(''))));
    });

    test('''Should perform getNowPlayingMovies() then return 
    ConnectionFailure when connection is unstable or no internet''', () async {
      // Arrange
      when(mockMovieServerSource.getNowPlayingMovies())
          .thenThrow(const SocketException('No Internet Connection'));

      // Act
      final result = await repository.getNowPlayingMovies();

      // Assert
      verify(mockMovieServerSource.getNowPlayingMovies());
      expect(
        result,
        equals(
          const Left(ConnectionFailure('No Internet Connection')),
        ),
      );
    });
  });

  group('''Popular Movie''', () {
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

    test('''Should perform getPopularMovies() then return 
    MovieList when the call server source is success ''', () async {
      // Arrange
      when(mockMovieServerSource.getPopularMovies())
          .thenAnswer((_) async => tMovieList);
      // Act
      final result = await repository.getPopularMovies();
      // Assert
      verify(mockMovieServerSource.getPopularMovies());
      expect(result, equals(Right(tMovieList)));
    });

    test('''Should perform getPopularMovies() then return 
    ServerFailure when the call server source is failed ''', () async {
      // Arrange

      when(mockMovieServerSource.getPopularMovies())
          .thenThrow(ServerException());
      // Act
      final result = await repository.getPopularMovies();

      // Assert
      verify(mockMovieServerSource.getPopularMovies());
      expect(result, equals(const Left(ServerFailure(''))));
    });

    test('''Should perform getPopularMovies() then return 
    ConnectionFailure when connection is unstable or no internet''', () async {
      // Arrange
      when(mockMovieServerSource.getPopularMovies())
          .thenThrow(const SocketException('No Internet Connection'));

      // Act
      final result = await repository.getPopularMovies();

      // Assert
      verify(mockMovieServerSource.getPopularMovies());
      expect(
        result,
        equals(const Left(ConnectionFailure('No Internet Connection'))),
      );
    });
  });

  group('''Top Rated Movie''', () {
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

    test('''Should perform getTopRatedMovies() then return 
    MovieList when the call server source is success ''', () async {
      // Arrange
      when(mockMovieServerSource.getTopRatedMovies())
          .thenAnswer((_) async => tMovieList);
      // Act
      final result = await repository.getTopRatedMovies();
      // Assert
      verify(mockMovieServerSource.getTopRatedMovies());
      expect(result, equals(Right(tMovieList)));
    });

    test('''Should perform getTopRatedMovies() then return 
    ServerFailure when the call server source is failed ''', () async {
      // Arrange

      when(mockMovieServerSource.getTopRatedMovies())
          .thenThrow(ServerException());
      // Act
      final result = await repository.getTopRatedMovies();

      // Assert
      verify(mockMovieServerSource.getTopRatedMovies());
      expect(result, equals(const Left(ServerFailure(''))));
    });

    test('''Should perform getTopRatedMovies() then return 
    ConnectionFailure when connection is unstable or no internet''', () async {
      // Arrange
      when(mockMovieServerSource.getTopRatedMovies())
          .thenThrow(const SocketException('No Internet Connection'));

      // Act
      final result = await repository.getTopRatedMovies();

      // Assert
      verify(mockMovieServerSource.getTopRatedMovies());
      expect(
        result,
        equals(const Left(ConnectionFailure('No Internet Connection'))),
      );
    });
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

    test('''Should perform GET Detail Movie and then
    return Movie when the call of server source is success''', () async {
      // Arrange
      when(mockMovieServerSource.getMovieDetail(tMovieId))
          .thenAnswer((_) async => tMovieDetail);
      // Act
      final result = await repository.getDetailMovie(tMovieId);
      // Assert
      verify(mockMovieServerSource.getMovieDetail(tMovieId));
      expect(result, equals(const Right(tMovieDetail)));
    });

    test('''Should perform GET Detail Movie and then return
    ServerFailure when the call of server source is failed''', () async {
      // Arrange
      when(mockMovieServerSource.getMovieDetail(tMovieId))
          .thenThrow(ServerException());
      // Act
      final result = await repository.getDetailMovie(tMovieId);
      // Assert
      verify(mockMovieServerSource.getMovieDetail(tMovieId));
      expect(result, equals(const Left(ServerFailure(''))));
    });

    test('''Should perform GET Detail Movie and then return 
    ConnectionFailure when connection is unstable or no internet''', () async {
      // Arrange
      when(mockMovieServerSource.getMovieDetail(tMovieId))
          .thenThrow(const SocketException('No Internet Connection'));
      // Act
      final result = await repository.getDetailMovie(tMovieId);
      // Assert
      verify(mockMovieServerSource.getMovieDetail(tMovieId));
      expect(
        result,
        equals(const Left(ConnectionFailure('No Internet Connection'))),
      );
    });
  });

  group('''Get Recommended Movie''', () {
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

    test('''Should perform GET Recommended Movie and then
    return MovieList when the call of server source is success''', () async {
      // Arrange
      when(mockMovieServerSource.getRecommendedMovies(tMovieId))
          .thenAnswer((_) async => tMovieList);
      // Act
      final result = await repository.getRecommendedMovies(tMovieId);
      // Assert
      verify(mockMovieServerSource.getRecommendedMovies(tMovieId));
      expect(result, equals(Right(tMovieList)));
    });

    test('''Should perform GET Recommended Movie and then return 
    ServerFailure when the call of server source is failed''', () async {
      // Arrange
      when(mockMovieServerSource.getRecommendedMovies(tMovieId))
          .thenThrow(ServerException());
      // Act
      final result = await repository.getRecommendedMovies(tMovieId);
      // Assert
      verify(mockMovieServerSource.getRecommendedMovies(tMovieId));
      expect(result, equals(const Left(ServerFailure(''))));
    });

    test('''Should perform GET Recommended Movie and then return 
    ConnectionFailure when connection is unstable or no internet''', () async {
      // Arrange
      when(mockMovieServerSource.getRecommendedMovies(tMovieId))
          .thenThrow(const SocketException('No Internet Connection'));
      // Act
      final result = await repository.getRecommendedMovies(tMovieId);
      // Assert
      verify(mockMovieServerSource.getRecommendedMovies(tMovieId));
      expect(
        result,
        equals(const Left(ConnectionFailure('No Internet Connection'))),
      );
    });
  });

  group('''Search Movie''', () {
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

    test('''Should perform Search Movie and then
    return MovieList when the call of server source is success''', () async {
      // Arrange
      when(mockMovieServerSource.searchMovies(tQuery))
          .thenAnswer((_) async => tMovieList);
      // Act
      final result = await repository.searchMovies(tQuery);
      // Assert
      verify(mockMovieServerSource.searchMovies(tQuery));
      expect(result, equals(Right(tMovieList)));
    });

    test('''Should perform Search Movie and then return 
    ServerFailure when the call of server source is failed''', () async {
      // Arrange
      when(mockMovieServerSource.searchMovies(tQuery))
          .thenThrow(ServerException());
      // Act
      final result = await repository.searchMovies(tQuery);
      // Assert
      verify(mockMovieServerSource.searchMovies(tQuery));
      expect(result, const Left(ServerFailure('')));
    });

    test('''Should perform Search Movie and then return 
    ConnectionFailure when connection is unstable or no internet''', () async {
      // Arrange
      when(mockMovieServerSource.searchMovies(tQuery))
          .thenThrow(const SocketException('No Internet Connection'));
      // Act
      final result = await repository.searchMovies(tQuery);
      // Assert
      verify(mockMovieServerSource.searchMovies(tQuery));
      expect(
        result,
        equals(const Left(ConnectionFailure('No Internet Connection'))),
      );
    });
  });
}
