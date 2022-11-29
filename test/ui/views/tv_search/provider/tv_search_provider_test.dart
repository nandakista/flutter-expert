import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:submission/core/constant/network_state.dart';
import 'package:submission/core/error/failure.dart';
import 'package:submission/domain/entities/tv.dart';
import 'package:submission/domain/usecases/search_tv.dart';
import 'package:submission/ui/views/tv_search/tv_search_provider.dart';

import 'tv_search_provider_test.mocks.dart';

@GenerateMocks([SearchTv])
void main() {
  late MockSearchTv mockSearchTv;
  late TvSearchProvider provider;
  late int providerCalledCount;

  setUp(() {
    providerCalledCount = 0;
    mockSearchTv = MockSearchTv();
    provider = TvSearchProvider(searchTv: mockSearchTv)
      ..addListener(() => providerCalledCount += 1);
  });

  test('''Initial State and data should be empty''', () {
    expect(provider.state, RequestState.initial);
    expect(provider.data, List<Tv>.empty());
    expect(provider.message, '');
  });

  test('''Should change state to Loading when usecase is called''', () {
    final tTvList = <Tv>[];
    const tQuery = 'test';
    // Arrange
    when(mockSearchTv(tQuery)).thenAnswer((_) async => Right(tTvList));
    // Act
    provider.onSearchTv(tQuery);
    // Assert
    expect(provider.state, RequestState.loading);
    expect(provider.data, List<Tv>.empty());
    expect(provider.message, '');
  });

  test('''Should GET (Search) Tv data from usecase and data is not empty 
  then change state to Success''', () async {
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
    // Arrange
    when(mockSearchTv(tQuery)).thenAnswer((_) async => Right(tTvList));
    // Act
    await provider.onSearchTv(tQuery);
    final result = provider.data;
    // Assert
    verify(mockSearchTv(tQuery));
    assert(result.isNotEmpty);
    expect(provider.state, RequestState.success);
    expect(result, tTvList);
    expect(provider.message, '');
    expect(providerCalledCount, 2);
  });

  test('''Should GET (Search) Tv data from usecase and data is empty
  then change state to Empty''', () async {
    const tQuery = 'test';
    final tTvList = <Tv>[];
    // Arrange
    when(mockSearchTv(tQuery)).thenAnswer((_) async => Right(tTvList));
    // Act
    await provider.onSearchTv(tQuery);
    final result = provider.data;
    // Assert
    verify(mockSearchTv(tQuery));
    assert(result.isEmpty);
    expect(provider.state, RequestState.empty);
    expect(
        provider.message, 'Oops we could not find what you were looking for!');
    expect(result, tTvList);
    expect(providerCalledCount, 2);
  });

  test('''Should perform GET Search Tv data from usecase then return
  error when data is failed to load''', () async {
    const tQuery = 'test';
    // Arrange
    when(mockSearchTv(tQuery)).thenAnswer(
      (_) async => const Left(ServerFailure('')),
    );
    // Act
    await provider.onSearchTv(tQuery);
    // Assert
    expect(provider.state, RequestState.error);
    expect(provider.message, '');
    expect(provider.data, List<Tv>.empty());
    expect(providerCalledCount, 2);
  });

  test('''Should perform GET Search Tv data from usecase then return
  error when failed connect to the internet''', () async {
    const tQuery = 'test';
    // Arrange
    when(mockSearchTv(tQuery)).thenAnswer(
      (_) async => const Left(ConnectionFailure('No Internet Connection')),
    );
    // Act
    await provider.onSearchTv(tQuery);
    // Assert
    expect(provider.state, RequestState.error);
    expect(provider.message, 'No Internet Connection');
    expect(provider.data, List<Tv>.empty());
    expect(providerCalledCount, 2);
  });
}
