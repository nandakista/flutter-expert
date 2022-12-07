import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:submission/core/error/failure.dart';
import 'package:submission/domain/entities/genre.dart';
import 'package:submission/domain/entities/movie.dart';
import 'package:submission/domain/entities/movie_detail.dart';
import 'package:submission/domain/usecases/get_detail_movie.dart';
import 'package:submission/domain/usecases/get_recommended_movies.dart';
import 'package:submission/domain/usecases/get_watchlist_movie_exist_status.dart';
import 'package:submission/domain/usecases/remove_watchlist_movie.dart';
import 'package:submission/domain/usecases/save_watchlist_movie.dart';
import 'package:submission/ui/views/detail/bloc/detail_bloc.dart';

import 'detail_bloc_test.mocks.dart';

@GenerateMocks([
  GetDetailMovie,
  GetRecommendedMovies,
  GetWatchlistMovieExistStatus,
  SaveWatchlistMovie,
  RemoveWatchlistMovie,
])
void main() {
  late DetailBloc detailBloc;
  late MockGetDetailMovie mockGetDetailMovie;
  late MockGetRecommendedMovies mockGetRecommendedMovies;
  late MockGetWatchlistMovieExistStatus mockGetWatchlistMovieExistStatus;
  late MockSaveWatchlistMovie mockSaveWatchlistMovie;
  late MockRemoveWatchlistMovie mockRemoveWatchlistMovie;

  setUp(() {
    mockGetDetailMovie = MockGetDetailMovie();
    mockGetRecommendedMovies = MockGetRecommendedMovies();
    mockGetWatchlistMovieExistStatus = MockGetWatchlistMovieExistStatus();
    mockSaveWatchlistMovie = MockSaveWatchlistMovie();
    mockRemoveWatchlistMovie = MockRemoveWatchlistMovie();
    detailBloc = DetailBloc(
      getDetailMovie: mockGetDetailMovie,
      getRecommendationsMovies: mockGetRecommendedMovies,
      getWatchlistExist: mockGetWatchlistMovieExistStatus,
      saveWatchlist: mockSaveWatchlistMovie,
      removeWatchlist: mockRemoveWatchlistMovie,
    );
  });

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

  test('Initial state should be empty', () {
    expect(detailBloc.state, DetailInitial());
  });

  blocTest<DetailBloc, DetailState>(
    'Should emit [Loading, HasData] when successfully get detail, '
    'successfully get recommended movies, and already save in watchlist '
    'so existing status watchlist is true',
    build: () {
      when(mockGetDetailMovie(tMovieId))
          .thenAnswer((_) async => const Right(tMovieDetail));
      when(mockGetRecommendedMovies(tMovieId))
          .thenAnswer((_) async => Right(tMovieList));
      when(mockGetWatchlistMovieExistStatus(tMovieId))
          .thenAnswer((_) async => true);
      return detailBloc;
    },
    act: (bloc) {
      bloc.add(const LoadDetailMovies(tMovieId));
    },
    wait: const Duration(milliseconds: 500),
    expect: () => [
      DetailLoading(),
      DetailHasData(
        detail: tMovieDetail,
        recommendedMovie: tMovieList,
        hasAddedToWatchList: true,
      ),
    ],
    verify: (bloc) {
      verify(mockGetDetailMovie(tMovieId));
      verify(mockGetRecommendedMovies(tMovieId));
      verify(mockGetWatchlistMovieExistStatus(tMovieId));
    },
  );

  blocTest<DetailBloc, DetailState>(
    'Should emit [Loading, HasData] when successfully get detail, '
    'successfully get recommended movies, and havent save in watchlist '
    'so existing status watchlist is false',
    build: () {
      when(mockGetDetailMovie(tMovieId))
          .thenAnswer((_) async => const Right(tMovieDetail));
      when(mockGetRecommendedMovies(tMovieId))
          .thenAnswer((_) async => Right(tMovieList));
      when(mockGetWatchlistMovieExistStatus(tMovieId))
          .thenAnswer((_) async => false);
      return detailBloc;
    },
    act: (bloc) {
      bloc.add(const LoadDetailMovies(tMovieId));
    },
    wait: const Duration(milliseconds: 500),
    expect: () => [
      DetailLoading(),
      DetailHasData(
        detail: tMovieDetail,
        recommendedMovie: tMovieList,
        hasAddedToWatchList: false,
      ),
    ],
    verify: (bloc) {
      verify(mockGetDetailMovie(tMovieId));
      verify(mockGetRecommendedMovies(tMovieId));
      verify(mockGetWatchlistMovieExistStatus(tMovieId));
    },
  );

  blocTest<DetailBloc, DetailState>(
    'when failed get detail, but successfully to get recommendation movie.'
    'Should emit [Loading, Error]',
    build: () {
      when(mockGetDetailMovie(tMovieId))
          .thenAnswer((_) async => const Left(ServerFailure('Server Failure')));
      when(mockGetRecommendedMovies(tMovieId))
          .thenAnswer((_) async => Right(tMovieList));
      when(mockGetWatchlistMovieExistStatus(tMovieId))
          .thenAnswer((_) async => true);
      return detailBloc;
    },
    act: (bloc) {
      bloc.add(const LoadDetailMovies(tMovieId));
    },
    wait: const Duration(milliseconds: 500),
    expect: () => [
      DetailLoading(),
      const DetailError('Server Failure'),
    ],
    verify: (bloc) {
      verify(mockGetDetailMovie(tMovieId));
      verify(mockGetRecommendedMovies(tMovieId));
      verify(mockGetWatchlistMovieExistStatus(tMovieId));
    },
  );

  blocTest<DetailBloc, DetailState>(
    'Should emit [Loading, Error] when successfully get detail, '
    'existing status watchlist, but failed to get recommendation movie',
    build: () {
      when(mockGetDetailMovie(tMovieId))
          .thenAnswer((_) async => const Right(tMovieDetail));
      when(mockGetRecommendedMovies(tMovieId))
          .thenAnswer((_) async => const Left(ServerFailure('Server Failure')));
      when(mockGetWatchlistMovieExistStatus(tMovieId))
          .thenAnswer((_) async => true);
      return detailBloc;
    },
    act: (bloc) {
      bloc.add(const LoadDetailMovies(tMovieId));
    },
    wait: const Duration(milliseconds: 500),
    expect: () => [
      DetailLoading(),
      const DetailError('Server Failure'),
    ],
    verify: (bloc) {
      verify(mockGetDetailMovie(tMovieId));
      verify(mockGetRecommendedMovies(tMovieId));
      verify(mockGetWatchlistMovieExistStatus(tMovieId));
    },
  );

  blocTest<DetailBloc, DetailState>(
    'when request detail movie with no internet connection Should emit [Loading, Error]',
    build: () {
      when(mockGetDetailMovie(tMovieId)).thenAnswer(
          (_) async => const Left(ConnectionFailure('No Internet')));
      when(mockGetRecommendedMovies(tMovieId))
          .thenAnswer((_) async => Right(tMovieList));
      when(mockGetWatchlistMovieExistStatus(tMovieId))
          .thenAnswer((_) async => true);
      return detailBloc;
    },
    act: (bloc) {
      bloc.add(const LoadDetailMovies(tMovieId));
    },
    wait: const Duration(milliseconds: 500),
    expect: () => [
      DetailLoading(),
      const DetailError('No Internet'),
    ],
    verify: (bloc) {
      verify(mockGetDetailMovie(tMovieId));
      verify(mockGetRecommendedMovies(tMovieId));
      verify(mockGetWatchlistMovieExistStatus(tMovieId));
    },
  );

  blocTest<DetailBloc, DetailState>(
    'when request get recommended tv with no internet connection Should emit [Loading, Error]',
    build: () {
      when(mockGetDetailMovie(tMovieId))
          .thenAnswer((_) async => const Right(tMovieDetail));
      when(mockGetRecommendedMovies(tMovieId)).thenAnswer(
          (_) async => const Left(ConnectionFailure('No Internet')));
      when(mockGetWatchlistMovieExistStatus(tMovieId))
          .thenAnswer((_) async => true);
      return detailBloc;
    },
    act: (bloc) {
      bloc.add(const LoadDetailMovies(tMovieId));
    },
    wait: const Duration(milliseconds: 500),
    expect: () => [
      DetailLoading(),
      const DetailError('No Internet'),
    ],
    verify: (bloc) {
      verify(mockGetDetailMovie(tMovieId));
      verify(mockGetRecommendedMovies(tMovieId));
      verify(mockGetWatchlistMovieExistStatus(tMovieId));
    },
  );

  blocTest<DetailBloc, DetailState>(
    'when successfully save to watchlist Should emit [HasData] with watchlistMessage'
    'from following message from usecase and change status watchlist to true',
    build: () {
      when(mockSaveWatchlistMovie(tMovieDetail))
          .thenAnswer((_) async => const Right('Added to Watchlist'));
      return detailBloc;
    },
    act: (bloc) {
      bloc.add(AddWatchlist(tMovieDetail, tMovieList));
    },
    wait: const Duration(milliseconds: 500),
    expect: () => [
      DetailHasData(
        detail: tMovieDetail,
        recommendedMovie: tMovieList,
        hasAddedToWatchList: true,
        watchlistMessage: 'Added to Watchlist',
      ),
    ],
    verify: (bloc) {
      verify(mockSaveWatchlistMovie(tMovieDetail));
    },
  );

  blocTest<DetailBloc, DetailState>(
    'when failed save to watchlist Should emit [HasData] with watchlistMessage'
    'from following message from usecase and status watchlist is still false',
    build: () {
      when(mockSaveWatchlistMovie(tMovieDetail)).thenAnswer(
          (_) async => const Left(DatabaseFailure('Failed save to watchlist')));
      return detailBloc;
    },
    act: (bloc) {
      bloc.add(AddWatchlist(tMovieDetail, tMovieList));
    },
    wait: const Duration(milliseconds: 500),
    expect: () => [
      DetailHasData(
        detail: tMovieDetail,
        recommendedMovie: tMovieList,
        hasAddedToWatchList: false,
        watchlistMessage: 'Failed save to watchlist',
      ),
    ],
    verify: (bloc) {
      verify(mockSaveWatchlistMovie(tMovieDetail));
    },
  );

  blocTest<DetailBloc, DetailState>(
    'when successfully remove from watchlist Should emit [HasData] with watchlistMessage'
    'from following message from usecase and change status watchlist to false',
    build: () {
      when(mockRemoveWatchlistMovie(tMovieDetail))
          .thenAnswer((_) async => const Right('Remove from Watchlist'));
      return detailBloc;
    },
    act: (bloc) {
      bloc.add(RemoveFromWatchlist(tMovieDetail, tMovieList));
    },
    wait: const Duration(milliseconds: 500),
    expect: () => [
      DetailHasData(
        detail: tMovieDetail,
        recommendedMovie: tMovieList,
        hasAddedToWatchList: false,
        watchlistMessage: 'Remove from Watchlist',
      ),
    ],
    verify: (bloc) {
      verify(mockRemoveWatchlistMovie(tMovieDetail));
    },
  );

  blocTest<DetailBloc, DetailState>(
    'when failed remove from watchlist Should emit [HasData] with watchlistMessage'
    'from following message from usecase and status watchlist is still true',
    build: () {
      when(mockRemoveWatchlistMovie(tMovieDetail)).thenAnswer(
          (_) async => const Left(DatabaseFailure('Failed remove')));
      return detailBloc;
    },
    act: (bloc) {
      bloc.add(RemoveFromWatchlist(tMovieDetail, tMovieList));
    },
    wait: const Duration(milliseconds: 500),
    expect: () => [
      DetailHasData(
        detail: tMovieDetail,
        recommendedMovie: tMovieList,
        hasAddedToWatchList: true,
        watchlistMessage: 'Failed remove',
      ),
    ],
    verify: (bloc) {
      verify(mockRemoveWatchlistMovie(tMovieDetail));
    },
  );
}
