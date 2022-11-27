import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:submission/domain/entities/genre.dart';
import 'package:submission/domain/entities/movie_detail.dart';
import 'package:submission/domain/repositories/movie_repository.dart';
import 'package:submission/domain/usecases/remove_watchlist.dart';

import 'remove_watchlist_test.mocks.dart';

@GenerateMocks([MovieRepository])
void main() {
  late RemoveWatchlist usecase;
  late MockMovieRepository mockMovieRepository;

  setUp(() {
    mockMovieRepository = MockMovieRepository();
    usecase = RemoveWatchlist(repository: mockMovieRepository);
  });

  test('Should remove Watchlist from repository', () async {
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
    when(mockMovieRepository.removeWatchlist(tMovieDetail))
        .thenAnswer((_) async => const Right('Removed from watchlist'));
    // Act
    final result = await usecase(tMovieDetail);
    // Assert
    verify(mockMovieRepository.removeWatchlist(tMovieDetail));
    expect(result, const Right('Removed from watchlist'));
  });
}
