import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:submission/core/constant/network_state.dart';
import 'package:submission/core/error/failure.dart';
import 'package:submission/domain/entities/genre.dart';
import 'package:submission/domain/entities/season.dart';
import 'package:submission/domain/entities/tv.dart';
import 'package:submission/domain/entities/tv_detail.dart';
import 'package:submission/domain/usecases/get_detail_tv.dart';
import 'package:submission/domain/usecases/get_recommended_tv.dart';
import 'package:submission/domain/usecases/get_watchlist_tv_exist_status.dart';
import 'package:submission/domain/usecases/remove_watchlist_tv.dart';
import 'package:submission/domain/usecases/save_watchlist_tv.dart';
import 'package:submission/ui/views/tv_detail/tv_detail_provider.dart';

import 'tv_detail_provider_test.mocks.dart';

@GenerateMocks([
  GetDetailTv,
  GetRecommendedTv,
  GetWatchlistTvExistStatus,
  SaveWatchlistTv,
  RemoveWatchlistTv,
])
void main() {
  late MockGetDetailTv mockGetDetailTv;
  late MockGetRecommendedTv mockGetRecommendedTv;
  late MockGetWatchlistTvExistStatus mockGetWatchlistTvExistStatus;
  late MockSaveWatchlistTv mockSaveWatchlistTv;
  late MockRemoveWatchlistTv mockRemoveWatchlistTv;
  late TvDetailProvider provider;
  late int providerCalledCount;

  setUp(() {
    providerCalledCount = 0;
    mockGetDetailTv = MockGetDetailTv();
    mockGetRecommendedTv = MockGetRecommendedTv();
    mockGetWatchlistTvExistStatus = MockGetWatchlistTvExistStatus();
    mockSaveWatchlistTv = MockSaveWatchlistTv();
    mockRemoveWatchlistTv = MockRemoveWatchlistTv();
    provider = TvDetailProvider(
      getDetailTv: mockGetDetailTv,
      getRecommendationsTv: mockGetRecommendedTv,
      getWatchlistExist: mockGetWatchlistTvExistStatus,
      saveWatchlist: mockSaveWatchlistTv,
      removeWatchlist: mockRemoveWatchlistTv,
    )..addListener(() => providerCalledCount += 1);
  });

  test('''Initial State and data should be empty''', () {
    expect(provider.detailState, RequestState.initial);
    expect(provider.recommendationState, RequestState.initial);
    expect(provider.recommendedTv, List<Tv>.empty());
    expect(provider.message, '');
  });

  group('''Detail Tv''', () {
    const tId = 94605;
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

    test('''Should change state to Loading when usecase is called''', () {
      // Arrange
      when(mockGetDetailTv(tId)).thenAnswer(
        (_) async => const Right(tTvDetail),
      );
      // Act
      provider.loadTvDetail(tId);
      // Assert
      expect(provider.detailState, RequestState.loading);
      expect(provider.message, '');
    });

    test('''Should GET Detail Tv data from usecase 
    and change state to Success''', () async {
      // Arrange
      when(mockGetDetailTv(tId))
          .thenAnswer((_) async => const Right(tTvDetail));
      // Act
      await provider.loadTvDetail(tId);
      final result = provider.detailTv;
      // Assert
      verify(mockGetDetailTv(tId));
      expect(provider.detailState, RequestState.success);
      expect(result, tTvDetail);
      expect(provider.message, '');
      expect(providerCalledCount, 2);
    });

    test('''Should perform GET Detail Tv data from usecase then return
    error when data is failed to load''', () async {
      // Arrange
      when(mockGetDetailTv(tId)).thenAnswer(
        (_) async => const Left(ServerFailure('')),
      );
      // Act
      await provider.loadTvDetail(tId);
      // Assert
      expect(provider.detailState, RequestState.error);
      expect(provider.message, '');
      expect(providerCalledCount, 2);
    });

    test('''Should perform GET Detail Tv data from usecase then return
    error when failed connect to the internet''', () async {
      // Arrange
      when(mockGetDetailTv(tId)).thenAnswer(
        (_) async => const Left(ConnectionFailure('No Internet Connection')),
      );
      // Act
      await provider.loadTvDetail(tId);
      // Assert
      expect(provider.detailState, RequestState.error);
      expect(provider.message, 'No Internet Connection');
      expect(providerCalledCount, 2);
    });
  });

  group('''Recommended Tv''', () {
    const tId = 436270;
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

    test('''Should change state to Loading when usecase is called''', () {
      // Arrange
      when(mockGetRecommendedTv(tId))
          .thenAnswer((_) async => Right(tTvList));
      // Act
      provider.loadRecommendedTv(tId);
      // Assert
      expect(provider.recommendationState, RequestState.loading);
      expect(provider.recommendedTv, List<Tv>.empty());
      expect(provider.message, '');
    });

    test('''Should GET Recommended Tv data from usecase and data is not empty
    then change state to Loaded''', () async {
      // Arrange
      when(mockGetRecommendedTv(tId))
          .thenAnswer((_) async => Right(tTvList));
      // Act
      await provider.loadRecommendedTv(tId);
      final result = provider.recommendedTv;
      // Assert
      verify(mockGetRecommendedTv(tId));
      assert(result.isNotEmpty);
      expect(provider.recommendationState, RequestState.success);
      expect(result, tTvList);
      expect(provider.message, '');
      expect(providerCalledCount, 2);
    });

    test('''Should GET Recommended Tv data from usecase and data is empty
  then change state to Empty''', () async {
      final tTvList = <Tv>[];
      // Arrange
      when(mockGetRecommendedTv(tId))
          .thenAnswer((_) async => Right(tTvList));
      // Act
      await provider.loadRecommendedTv(tId);
      final result = provider.recommendedTv;
      // Assert
      verify(mockGetRecommendedTv(tId));
      assert(result.isEmpty);
      expect(provider.recommendationState, RequestState.empty);
      expect(result, tTvList);
      expect(provider.message, 'No Recommendations Found');
      expect(providerCalledCount, 2);
    });

    test('''Should perform GET Recommended Tv data from usecase then return
    error when data is failed to load''', () async {
      // Arrange
      when(mockGetRecommendedTv(tId)).thenAnswer(
        (_) async => const Left(ServerFailure('')),
      );
      // Act
      await provider.loadRecommendedTv(tId);
      // Assert
      expect(provider.recommendationState, RequestState.error);
      expect(provider.message, '');
      expect(provider.recommendedTv, List<Tv>.empty());
      expect(providerCalledCount, 2);
    });

    test('''Should perform GET Recommended Tv data from usecase then return
    error when failed connect to the internet''', () async {
      // Arrange
      when(mockGetRecommendedTv(tId)).thenAnswer(
        (_) async => const Left(ConnectionFailure('No Internet Connection')),
      );
      // Act
      await provider.loadRecommendedTv(tId);
      // Assert
      expect(provider.recommendationState, RequestState.error);
      expect(provider.message, 'No Internet Connection');
      expect(provider.recommendedTv, List<Tv>.empty());
      expect(providerCalledCount, 2);
    });
  });
}
