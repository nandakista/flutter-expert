import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:submission/domain/entities/genre.dart';
import 'package:submission/domain/entities/movie_detail.dart';
import 'package:submission/domain/repositories/movie_repository.dart';
import 'package:submission/domain/usecases/save_watchlist.dart';

import 'save_watchlist_test.mocks.dart';

@GenerateMocks([MovieRepository])
void main() {
  late SaveWatchlist usecase;
  late MockMovieRepository mockMovieRepository;

  setUp(() {
    mockMovieRepository = MockMovieRepository();
    usecase = SaveWatchlist(repository: mockMovieRepository);
  });

  test('Should save movie to the repository', () async {
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

    // Arrange
    when(mockMovieRepository.saveWatchlist(tMovieDetail))
        .thenAnswer((_) async => const Right('Added to Watchlist'));
    // Act
    final result = await usecase(tMovieDetail);
    // Assert
    verify(mockMovieRepository.saveWatchlist(tMovieDetail));
    expect(result, const Right('Added to Watchlist'));
  });
}