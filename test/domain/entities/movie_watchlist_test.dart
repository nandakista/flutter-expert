import 'package:flutter_test/flutter_test.dart';
import 'package:submission/domain/entities/genre.dart';
import 'package:submission/domain/entities/movie.dart';
import 'package:submission/domain/entities/movie_detail.dart';
import 'package:submission/domain/entities/movie_watchlist.dart';

void main() {
  const tMovieWatchlist = MovieWatchlist(
    id: 436270,
    title: 'Black Adam',
    posterPath: '/pFlaoHTZeyNkG83vxsAJiGzfSsa.jpg',
    overview: 'Some Overview',
    voteAverage: 6.8,
  );

  group('''toEntity''', () {
    test('''Should convert Movie Watchlist to Movie''', () {
      // Arrange
      const tMovie = Movie(
        id: 436270,
        title: 'Black Adam',
        posterPath: '/pFlaoHTZeyNkG83vxsAJiGzfSsa.jpg',
        overview: 'Some Overview',
        voteAverage: 6.8,
      );
      // Act
      final result = tMovieWatchlist.toEntity();
      // Assert
      expect(result, tMovie);
    });
  });

  group('''fromEntity''', () {
    test('''Should convert Movie Detail into Movie Watchlist''', () {
      // Arrange
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
      // Act
      final result = MovieWatchlist.fromEntity(tMovieDetail);
      // Assert
      expect(result, tMovieWatchlist);
    });
  });
}
