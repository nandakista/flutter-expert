import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:submission/data/models/genre_model.dart';
import 'package:submission/data/models/season_model.dart';
import 'package:submission/data/models/tv_detail_model.dart';
import 'package:submission/domain/entities/tv_detail.dart';

import '../../core/fixture/fixture_reader.dart';

void main() {
  const tTvDetailModel = TvDetailModel(
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

  test('''Should be a subclass of Tv Entity''', () {
    // Assert
    expect(tTvDetailModel, isA<TvDetail>());
  });

  group('''fromJson''', () {
    test('''Should return a valid model when parsing JSON map''', () {
      // Arrange
      final Map<String, dynamic> jsonMap = json.decode(
        fixture('entity/tv_detail.json'),
      );
      // Act
      final result = TvDetailModel.fromJson(jsonMap);
      // Assert
      expect(result, tTvDetailModel);
    });
  });

  group('''toJson''', () {
    test('''Should return a JSON map containing the proper data ''', () {
      // Act
      final result = tTvDetailModel.toJson();
      // Assert
      final expectedMap = json.decode(fixture('entity/tv_detail.json'));
      expect(result, expectedMap);
    });
  });
}
