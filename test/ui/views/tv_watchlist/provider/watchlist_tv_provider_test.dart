import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:submission/core/constant/network_state.dart';
import 'package:submission/core/error/failure.dart';
import 'package:submission/domain/entities/tv.dart';
import 'package:submission/domain/usecases/get_watchlist_tv.dart';
import 'package:submission/ui/views/watchlist/tv/watchlist_tv_provider.dart';

import 'watchlist_tv_provider_test.mocks.dart';

@GenerateMocks([GetWatchlistTv])
void main() {
  late WatchlistTvProvider provider;
  late MockGetWatchlistTv mockGetWatchlistTv;
  late int listenerCallCount;

  setUp(() {
    listenerCallCount = 0;
    mockGetWatchlistTv = MockGetWatchlistTv();
    provider = WatchlistTvProvider(
      getWatchlist: mockGetWatchlistTv,
    )..addListener(() {
        listenerCallCount += 1;
      });
  });

  test(
      'Should perform Get Watchlist from usecase, if return '
      'empty then change state to Success', () async {
    final tTvList = <Tv>[];

    // Arrange
    when(mockGetWatchlistTv()).thenAnswer((_) async => Right(tTvList));
    // Act
    await provider.loadData();
    // Assert
    expect(provider.state, RequestState.empty);
    expect(provider.data, tTvList);
    expect(listenerCallCount, 2);
  });

  test(
      'Should perform Get Watchlist from usecase then return '
      'change state to Success', () async {
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

    // Arrange
    when(mockGetWatchlistTv()).thenAnswer((_) async => Right(tTvList));
    // Act
    await provider.loadData();
    // Assert
    expect(provider.state, RequestState.success);
    expect(provider.data, tTvList);
    expect(listenerCallCount, 2);
  });

  test(
      'Should perform Get Watchlist from usecase then return '
      'error DatabaseFailure and change state to Error', () async {
    // Arrange
    when(mockGetWatchlistTv())
        .thenAnswer((_) async => const Left(DatabaseFailure("Error")));
    // Act
    await provider.loadData();
    // Assert
    expect(provider.state, RequestState.error);
    expect(provider.message, "Error");
    expect(listenerCallCount, 2);
  });
}
