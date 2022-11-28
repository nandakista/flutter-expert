import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:submission/core/error/exception.dart';
import 'package:submission/core/error/failure.dart';
import 'package:submission/data/repositories/tv_repository_impl.dart';
import 'package:submission/data/sources/local/tv_local_source.dart';
import 'package:submission/data/sources/server/tv_server_source.dart';
import 'package:submission/domain/entities/genre.dart';
import 'package:submission/domain/entities/season.dart';
import 'package:submission/domain/entities/tv.dart';
import 'package:submission/domain/entities/tv_detail.dart';
import 'package:submission/domain/entities/watchlist.dart';

import 'tv_repository_test.mocks.dart';

@GenerateMocks([TvServerSource, TvLocalSource])
void main() {
  late TvRepositoryImpl repository;
  late MockTvServerSource mockTvServerSource;
  late MockTvLocalSource mockTvLocalSource;

  setUp(() {
    mockTvServerSource = MockTvServerSource();
    mockTvLocalSource = MockTvLocalSource();
    repository = TvRepositoryImpl(
      serverSource: mockTvServerSource,
      localDataSource: mockTvLocalSource,
    );
  });

  group('''Get On Air Tv''', () {
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

    test('''Should return Tv List when call source is success''', () async {
      // Arrange
      when(mockTvServerSource.getOnAirTv()).thenAnswer((_) async => tTvList);
      // Act
      final result = await repository.getOnAirTv();
      // Assert
      verify(mockTvServerSource.getOnAirTv());
      expect(result, equals(Right(tTvList)));
    });

    test('''Should return ServerFailure when call source is failed''',
        () async {
      // Arrange
      when(mockTvServerSource.getOnAirTv()).thenThrow(ServerException());
      // Act
      final result = await repository.getOnAirTv();
      // Assert
      verify(mockTvServerSource.getOnAirTv());
      expect(result, equals(const Left(ServerFailure(''))));
    });

    test('''Should return ConnectionFailure when no internet''', () async {
      // Arrange
      when(mockTvServerSource.getOnAirTv())
          .thenThrow(const SocketException('No Internet Connection'));
      // Act
      final result = await repository.getOnAirTv();
      // Assert
      verify(mockTvServerSource.getOnAirTv());
      expect(
        result,
        equals(
          const Left(ConnectionFailure('No Internet Connection')),
        ),
      );
    });
  });

  group('''Get Popular Tv''', () {
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

    test('''Should return Tv List when call source is success''', () async {
      // Arrange
      when(mockTvServerSource.getPopularTv()).thenAnswer((_) async => tTvList);
      // Act
      final result = await repository.getPopularTv();
      // Assert
      verify(mockTvServerSource.getPopularTv());
      expect(result, equals(Right(tTvList)));
    });

    test('''Should return ServerFailure when call source is failed''',
        () async {
      // Arrange
      when(mockTvServerSource.getPopularTv()).thenThrow(ServerException());
      // Act
      final result = await repository.getPopularTv();
      // Assert
      verify(mockTvServerSource.getPopularTv());
      expect(result, equals(const Left(ServerFailure(''))));
    });

    test('''Should return ConnectionFailure when no internet''', () async {
      // Arrange
      when(mockTvServerSource.getPopularTv())
          .thenThrow(const SocketException('No Internet Connection'));
      // Act
      final result = await repository.getPopularTv();
      // Assert
      verify(mockTvServerSource.getPopularTv());
      expect(
        result,
        equals(const Left(ConnectionFailure('No Internet Connection'))),
      );
    });
  });

  group('''Get Top Rated Tv''', () {
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

    test('''Should return Tv List when call source is success''', () async {
      // Arrange
      when(mockTvServerSource.getTopRatedTv()).thenAnswer((_) async => tTvList);
      // Act
      final result = await repository.getTopRatedTv();
      // Assert
      verify(mockTvServerSource.getTopRatedTv());
      expect(result, equals(Right(tTvList)));
    });

    test('''Should return ServerFailure when call source is failed''',
        () async {
      // Arrange
      when(mockTvServerSource.getTopRatedTv()).thenThrow(ServerException());
      // Act
      final result = await repository.getTopRatedTv();
      // Assert
      verify(mockTvServerSource.getTopRatedTv());
      expect(result, equals(const Left(ServerFailure(''))));
    });

    //
    test('''Should return ConnectionFailure when no internet''', () async {
      // Arrange
      when(mockTvServerSource.getTopRatedTv())
          .thenThrow(const SocketException('No Internet Connection'));
      // Act
      final result = await repository.getTopRatedTv();
      // Assert
      verify(mockTvServerSource.getTopRatedTv());
      expect(
        result,
        equals(const Left(ConnectionFailure('No Internet Connection'))),
      );
    });
  });

  group('''Get Recommendation Tv''', () {
    const tId = 60625;
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

    test('''Should return Tv List when call source is success''', () async {
      // Arrange
      when(mockTvServerSource.getRecommendedTv(tId))
          .thenAnswer((_) async => tTvList);
      // Act
      final result = await repository.getRecommendedTv(tId);
      // Assert
      verify(mockTvServerSource.getRecommendedTv(tId));
      expect(result, equals(Right(tTvList)));
    });

    test('''Should return ServerFailure when call source is failed''',
        () async {
      // Arrange
      when(mockTvServerSource.getRecommendedTv(tId))
          .thenThrow(ServerException());
      // Act
      final result = await repository.getRecommendedTv(tId);
      // Assert
      verify(mockTvServerSource.getRecommendedTv(tId));
      expect(result, equals(const Left(ServerFailure(''))));
    });

    test('''Should return ConnectionFailure when no internet''', () async {
      // Arrange
      when(mockTvServerSource.getRecommendedTv(tId))
          .thenThrow(const SocketException('No Internet Connection'));
      // Act
      final result = await repository.getRecommendedTv(tId);
      // Assert
      verify(mockTvServerSource.getRecommendedTv(tId));
      expect(
        result,
        equals(const Left(ConnectionFailure('No Internet Connection'))),
      );
    });
  });

  group('''Get Detail Tv''', () {
    const tId = 436270;
    const tTvDetail = TvDetail(
      adult: false,
      backdropPath: "/url.jpg",
      episodeRunTime: [39],
      firstAirDate: "2021-11-06",
      genres: [
        Genre(id: 16, name: "Animation"),
        Genre(id: 10765, name: "Sci-Fi & Fantasy"),
      ],
      homepage: "https://arcane.com",
      id: 94605,
      inProduction: true,
      languages: ["am", "ar", "en", "hz"],
      lastAirDate: "2021-11-20",
      name: "Arcane",
      nextEpisodeToAir: null,
      numberOfEpisodes: 9,
      numberOfSeasons: 2,
      originCountry: ["US"],
      originalLanguage: "en",
      originalName: "Arcane",
      overview: "overview",
      popularity: 95.866,
      posterPath: "/url.jpg",
      seasons: [
        Season(
            airDate: "2021-11-06",
            episodeCount: 9,
            id: 134187,
            name: "Season 1",
            overview: "",
            posterPath: "/url.jpg",
            seasonNumber: 1)
      ],
      status: "Returning Series",
      tagline: "",
      type: "Scripted",
      voteAverage: 8.746,
      voteCount: 2704,
    );

    test('''Should return Detail Tv when call source is success''', () async {
      // Arrange
      when(mockTvServerSource.getTvDetail(tId))
          .thenAnswer((_) async => tTvDetail);
      // Act
      final result = await repository.getDetailTv(tId);
      // Assert
      verify(mockTvServerSource.getTvDetail(tId));
      expect(result, equals(const Right(tTvDetail)));
    });

    test('''Should return ServerFailure when call source is failed''',
        () async {
      // Arrange
      when(mockTvServerSource.getTvDetail(tId)).thenThrow(ServerException());
      // Act
      final result = await repository.getDetailTv(tId);
      // Assert
      verify(mockTvServerSource.getTvDetail(tId));
      expect(result, equals(const Left(ServerFailure(''))));
    });

    test('''Should return ConnectionFailure when no internet''', () async {
      // Arrange
      when(mockTvServerSource.getTvDetail(tId))
          .thenThrow(const SocketException('No Internet Connection'));
      // Act
      final result = await repository.getDetailTv(tId);
      // Assert
      verify(mockTvServerSource.getTvDetail(tId));
      expect(
        result,
        equals(const Left(ConnectionFailure('No Internet Connection'))),
      );
    });
  });

  group('''Search Tv''', () {
    const tQuery = 'test';
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

    test('''Should return Tv List when call source is success''', () async {
      // Arrange
      when(mockTvServerSource.searchTv(tQuery))
          .thenAnswer((_) async => tTvList);
      // Act
      final result = await repository.searchTv(tQuery);
      // Assert
      verify(mockTvServerSource.searchTv(tQuery));
      expect(result, equals(Right(tTvList)));
    });

    test('''Should return ServerFailure when call source is failed''',
        () async {
      // Arrange
      when(mockTvServerSource.searchTv(tQuery)).thenThrow(ServerException());
      // Act
      final result = await repository.searchTv(tQuery);
      // Assert
      verify(mockTvServerSource.searchTv(tQuery));
      expect(result, const Left(ServerFailure('')));
    });

    test('''Should return ConnectionFailure when no internet''', () async {
      // Arrange
      when(mockTvServerSource.searchTv(tQuery))
          .thenThrow(const SocketException('No Internet Connection'));
      // Act
      final result = await repository.searchTv(tQuery);
      // Assert
      verify(mockTvServerSource.searchTv(tQuery));
      expect(
        result,
        equals(const Left(ConnectionFailure('No Internet Connection'))),
      );
    });
  });

  group('''Save Watchlist Tv''', () {
    const tTvWatchlist = Watchlist(
      id: 94605,
      title: 'Arcane',
      posterPath: '/url.jpg',
      overview: 'overview',
      voteAverage: 8.746,
    );

    const tTvDetail = TvDetail(
      adult: false,
      backdropPath: "/url.jpg",
      episodeRunTime: [39],
      firstAirDate: "2021-11-06",
      genres: [
        Genre(id: 16, name: "Animation"),
        Genre(id: 10765, name: "Sci-Fi & Fantasy"),
      ],
      homepage: "https://arcane.com",
      id: 94605,
      inProduction: true,
      languages: ["am", "ar", "en", "hz"],
      lastAirDate: "2021-11-20",
      name: "Arcane",
      nextEpisodeToAir: null,
      numberOfEpisodes: 9,
      numberOfSeasons: 2,
      originCountry: ["US"],
      originalLanguage: "en",
      originalName: "Arcane",
      overview: "overview",
      popularity: 95.866,
      posterPath: "/url.jpg",
      seasons: [
        Season(
          airDate: "2021-11-06",
          episodeCount: 9,
          id: 134187,
          name: "Season 1",
          overview: "",
          posterPath: "/url.jpg",
          seasonNumber: 1,
        )
      ],
      status: "Returning Series",
      tagline: "",
      type: "Scripted",
      voteAverage: 8.746,
      voteCount: 2704,
    );

    test('''Should return success message when successfully saving''',
        () async {
      // Arrange
      when(mockTvLocalSource.insertWatchlist(tTvWatchlist))
          .thenAnswer((_) async => 'Added to Watchlist');
      // Act
      final result = await repository.saveWatchlist(tTvDetail);
      // Assert
      expect(result, const Right('Added to Watchlist'));
    });

    test('''Should return DatabaseFailure when unsuccessfully saving''',
        () async {
      // Arrange
      when(mockTvLocalSource.insertWatchlist(tTvWatchlist))
          .thenThrow(DatabaseException('Failed to add watchlist'));
      // Act
      final result = await repository.saveWatchlist(tTvDetail);
      // Assert
      expect(result, const Left(DatabaseFailure('Failed to add watchlist')));
    });
  });

  group('''Remove Watchlist Tv''', () {
    const tTvWatchlist = Watchlist(
      id: 94605,
      title: 'Arcane',
      posterPath: '/url.jpg',
      overview: 'overview',
      voteAverage: 8.746,
    );

    const tTvDetail = TvDetail(
      adult: false,
      backdropPath: "/url.jpg",
      episodeRunTime: [39],
      firstAirDate: "2021-11-06",
      genres: [
        Genre(id: 16, name: "Animation"),
        Genre(id: 10765, name: "Sci-Fi & Fantasy"),
      ],
      homepage: "https://arcane.com",
      id: 94605,
      inProduction: true,
      languages: ["am", "ar", "en", "hz"],
      lastAirDate: "2021-11-20",
      name: "Arcane",
      nextEpisodeToAir: null,
      numberOfEpisodes: 9,
      numberOfSeasons: 2,
      originCountry: ["US"],
      originalLanguage: "en",
      originalName: "Arcane",
      overview: "overview",
      popularity: 95.866,
      posterPath: "/url.jpg",
      seasons: [
        Season(
          airDate: "2021-11-06",
          episodeCount: 9,
          id: 134187,
          name: "Season 1",
          overview: "",
          posterPath: "/url.jpg",
          seasonNumber: 1,
        )
      ],
      status: "Returning Series",
      tagline: "",
      type: "Scripted",
      voteAverage: 8.746,
      voteCount: 2704,
    );

    test('''Should return success message when successfully remove''',
        () async {
      // Arrange
      when(mockTvLocalSource.removeWatchlist(tTvWatchlist))
          .thenAnswer((_) async => 'Removed from watchlist');
      // Act
      final result = await repository.removeWatchlist(tTvDetail);
      // Assert
      expect(result, const Right('Removed from watchlist'));
    });

    test('''Should return DatabaseFailure when unsuccessfully remove''',
        () async {
      // Arrange
      when(mockTvLocalSource.removeWatchlist(tTvWatchlist))
          .thenThrow(DatabaseException('Failed to remove watchlist'));
      // Act
      final result = await repository.removeWatchlist(tTvDetail);
      // Assert
      expect(result, const Left(DatabaseFailure('Failed to remove watchlist')));
    });
  });

  group('''Get Watchlist Tv''', () {
    const tTvWatchlistList = [
      Watchlist(
        id: 60625,
        title: 'Rick and Morty',
        posterPath: '/url.jpg',
        overview: 'overview',
        voteAverage: 8.7,
      ),
    ];

    final tTvList = [
      const Tv(
        id: 60625,
        name: 'Rick and Morty',
        posterPath: '/url.jpg',
        overview: 'overview',
        voteAverage: 8.7,
      ),
    ];

    test('''Should return Tv List when successfully get watchlist tv''',
        () async {
      // Arrange
      when(mockTvLocalSource.getAllWatchlist())
          .thenAnswer((_) async => tTvWatchlistList);
      // Act
      final result = await repository.getAllWatchlist();
      // Assert
      final resultList = result.getOrElse(() => []);
      expect(resultList, tTvList);
    });
  });

  group('''Get Watchlist Exist Status''', () {
    const tId = 1;
    test('''Should return watchlist status whether data is found''', () async {
      // Arrange
      when(mockTvLocalSource.getWatchlist(tId)).thenAnswer((_) async => null);
      // Act
      final result = await repository.hasAddedToWatchlist(tId);
      // Assert
      expect(result, false);
    });
  });
}
