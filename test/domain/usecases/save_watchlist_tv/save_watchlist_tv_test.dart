import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:submission/data/models/genre_model.dart';
import 'package:submission/data/models/season_model.dart';
import 'package:submission/domain/entities/tv_detail.dart';
import 'package:submission/domain/repositories/tv_repository.dart';
import 'package:submission/domain/usecases/save_watchlist_tv.dart';

import 'save_watchlist_tv_test.mocks.dart';

@GenerateMocks([TvRepository])
void main() {
  late SaveWatchlistTv usecase;
  late MockTvRepository mockTvRepository;

  setUp(() {
    mockTvRepository = MockTvRepository();
    usecase = SaveWatchlistTv(repository: mockTvRepository);
  });

  test('Should save tv to the repository', () async {
    const tTvDetail = TvDetail(
      adult: false,
      backdropPath: "/url.jpg",
      episodeRunTime: [39],
      firstAirDate: "2021-11-06",
      genres: [
        GenreModel(id: 16, name: "Animation"),
        GenreModel(id: 10765, name: "Sci-Fi & Fantasy")
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
        SeasonModel(
          airDate: "2021-11-06",
          episodeCount: 9,
          id: 134187,
          name: "Season 1",
          overview: "",
          posterPath: "/url.jpg",
          seasonNumber: 1,
        ),
      ],
      status: "Returning Series",
      tagline: "",
      type: "Scripted",
      voteAverage: 8.746,
      voteCount: 2704,
    );

    // Arrange
    when(mockTvRepository.saveWatchlist(tTvDetail))
        .thenAnswer((_) async => const Right('Added to Watchlist'));
    // Act
    final result = await usecase(tTvDetail);
    // Assert
    verify(mockTvRepository.saveWatchlist(tTvDetail));
    expect(result, const Right('Added to Watchlist'));
  });
}