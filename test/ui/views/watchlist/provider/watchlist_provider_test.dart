import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:submission/core/constant/network_state.dart';
import 'package:submission/core/error/failure.dart';
import 'package:submission/domain/entities/movie.dart';
import 'package:submission/domain/usecases/get_watchlist.dart';
import 'package:submission/ui/views/watchlist/watchlist_provider.dart';

import 'watchlist_provider_test.mocks.dart';

@GenerateMocks([GetWatchlist])
void main() {
  late WatchlistProvider provider;
  late MockGetWatchlist mockGetWatchlist;
  late int listenerCallCount;

  setUp(() {
    listenerCallCount = 0;
    mockGetWatchlist = MockGetWatchlist();
    provider = WatchlistProvider(
      getWatchlist: mockGetWatchlist,
    )..addListener(() {
        listenerCallCount += 1;
      });
  });

  test(
      'Should perform Get Watchlist from usecase, if return '
      'empty then change state to Success', () async {
    final tMovieList = <Movie>[];

    // Arrange
    when(mockGetWatchlist())
        .thenAnswer((_) async => Right(tMovieList));
    // Act
    await provider.loadData();
    // Assert
    expect(provider.state, RequestState.empty);
    expect(provider.data, tMovieList);
    expect(listenerCallCount, 2);
  });

  test(
      'Should perform Get Watchlist from usecase then return '
          'change state to Success', () async {
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
    when(mockGetWatchlist()).thenAnswer((_) async => Right(tMovieList));
    // Act
    await provider.loadData();
    // Assert
    expect(provider.state, RequestState.success);
    expect(provider.data, tMovieList);
    expect(listenerCallCount, 2);
  });

  test(
      'Should perform Get Watchlist from usecase then return '
      'error DatabaseFailure and change state to Error', () async {
    // Arrange
    when(mockGetWatchlist())
        .thenAnswer((_) async => const Left(DatabaseFailure("Error")));
    // Act
    await provider.loadData();
    // Assert
    expect(provider.state, RequestState.error);
    expect(provider.message, "Error");
    expect(listenerCallCount, 2);
  });
}
