import 'package:flutter_test/flutter_test.dart';
import 'package:submission/data/models/genre_model.dart';
import 'package:submission/data/models/season_model.dart';
import 'package:submission/domain/entities/genre.dart';
import 'package:submission/domain/entities/movie.dart';
import 'package:submission/domain/entities/movie_detail.dart';
import 'package:submission/domain/entities/watchlist.dart';
import 'package:submission/domain/entities/tv.dart';
import 'package:submission/domain/entities/tv_detail.dart';

void main() {
  const tWatchlist = MovieWatchlist(
    id: 436270,
    title: 'Black Adam',
    posterPath: '/pFlaoHTZeyNkG83vxsAJiGzfSsa.jpg',
    overview: 'Some Overview',
    voteAverage: 6.8,
  );

  group('''toMovieEntity''', () {
    test('''Should convert Watchlist to Movie''', () {
      // Arrange
      const tMovie = Movie(
        id: 436270,
        title: 'Black Adam',
        posterPath: '/pFlaoHTZeyNkG83vxsAJiGzfSsa.jpg',
        overview: 'Some Overview',
        voteAverage: 6.8,
      );
      // Act
      final result = tWatchlist.toMovieEntity();
      // Assert
      expect(result, tMovie);
    });
  });

  group('''fromMovieEntity''', () {
    test('''Should convert Movie Detail into Watchlist''', () {
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
      final result = MovieWatchlist.fromMovieEntity(tMovieDetail);
      // Assert
      expect(result, tWatchlist);
    });

    group('''toTvEntity''', () {
      test('''Should convert Watchlist to Tv''', () {
        // Arrange
        const tTv = Tv(
          id: 436270,
          name: 'Black Adam',
          posterPath: '/pFlaoHTZeyNkG83vxsAJiGzfSsa.jpg',
          overview: 'Some Overview',
          voteAverage: 6.8,
        );
        // Act
        final result = tWatchlist.toTvEntity();
        // Assert
        expect(result, tTv);
      });
    });

    group('''fromMovieEntity''', () {
      test('''Should convert Tv Detail into Watchlist''', () {
        // Arrange
        const tTvDetail = TvDetail(
          adult: false,
          backdropPath: "/pFlaoHTZeyNkG83vxsAJiGzfSsa.jpg",
          episodeRunTime: [39],
          firstAirDate: "2021-11-06",
          genres: [
            GenreModel(id: 16, name: "Animation"),
            GenreModel(id: 10765, name: "Sci-Fi & Fantasy")
          ],
          homepage: "https://arcane.com",
          id: 436270,
          inProduction: true,
          languages: ["am", "ar", "en", "hz"],
          lastAirDate: "2021-11-20",
          name: "Black Adam",
          nextEpisodeToAir: null,
          numberOfEpisodes: 9,
          numberOfSeasons: 2,
          originCountry: ["US"],
          originalLanguage: "en",
          originalName: "Black Adam",
          overview: "Some Overview",
          popularity: 95.866,
          posterPath: "/pFlaoHTZeyNkG83vxsAJiGzfSsa.jpg",
          seasons: [
            SeasonModel(
              airDate: "2021-11-06",
              episodeCount: 9,
              id: 134187,
              name: "Season 1",
              overview: "",
              posterPath: "/pFlaoHTZeyNkG83vxsAJiGzfSsa.jpg",
              seasonNumber: 1,
            ),
          ],
          status: "Returning Series",
          tagline: "",
          type: "Scripted",
          voteAverage: 6.8,
          voteCount: 2704,
        );
        // Act
        final result = MovieWatchlist.fromTvEntity(tTvDetail);
        // Assert
        expect(result, tWatchlist);
      });
    });
  });
}
