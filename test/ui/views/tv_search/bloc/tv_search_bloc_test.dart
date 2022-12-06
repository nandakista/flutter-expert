import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:submission/core/error/failure.dart';
import 'package:submission/domain/entities/tv.dart';
import 'package:submission/domain/usecases/search_tv.dart';
import 'package:submission/ui/views/tv_search/bloc/tv_search_bloc.dart';

import 'tv_search_bloc_test.mocks.dart';

@GenerateMocks([SearchTv])
void main() {
  late TvSearchBloc tvSearchBloc;
  late MockSearchTv mockSearchTv;

  setUp(() {
    mockSearchTv = MockSearchTv();
    tvSearchBloc = TvSearchBloc(mockSearchTv);
  });

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
  const tQuery = 'black adam';

  test('initial state should be empty', () {
    expect(tvSearchBloc.state, TvSearchInitial());
  });

  blocTest<TvSearchBloc, TvSearchState>(
    'Should emit [Loading, HasData] when data is gotten successfully',
    build: () {
      when(mockSearchTv(tQuery)).thenAnswer((_) async => Right(tTvList));
      return tvSearchBloc;
    },
    act: (bloc) => bloc.add(const OnQueryChanged(tQuery)),
    wait: const Duration(milliseconds: 500),
    expect: () => [
      TvSearchLoading(),
      TvSearchHasData(tTvList),
    ],
    verify: (bloc) {
      verify(mockSearchTv(tQuery));
    },
  );

  blocTest<TvSearchBloc, TvSearchState>(
    'Should emit [Loading, Error] when get search is unsuccessful',
    build: () {
      when(mockSearchTv(tQuery))
          .thenAnswer((_) async => const Left(ServerFailure('Server Failure')));
      return tvSearchBloc;
    },
    act: (bloc) => bloc.add(const OnQueryChanged(tQuery)),
    wait: const Duration(milliseconds: 500),
    expect: () => [
      TvSearchLoading(),
      const TvSearchError('Server Failure'),
    ],
    verify: (bloc) {
      verify(mockSearchTv(tQuery));
    },
  );
}
