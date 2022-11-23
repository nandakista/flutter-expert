import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:submission/data/models/genre_model.dart';
import 'package:submission/data/models/movie_detail_model.dart';
import 'package:submission/domain/entities/movie_detail.dart';

import '../../core/fixture/fixture_reader.dart';

void main() {
  const tMovieDetailModel = MovieDetailModel(
    adult: false,
    backdropPath: '/bQXAqRx2Fgc46uCVWgoPz5L5Dtr.jpg',
    genres: [
      GenreModel(id: 28, name: 'Action'),
      GenreModel(id: 14, name: 'Fantasy'),
      GenreModel(id: 878, name: 'Science Fiction'),
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
    originalLanguage: 'en',
    popularity: 23828.993,
    revenue: 351000000,
    status: 'Released',
    tagline: 'The world needed a hero. It got Black Adam.',
    video: false,
  );

  test('''Should be a subclass of Movie Detail Entity''', () {
    // Assert
    expect(tMovieDetailModel, isA<MovieDetail>());
  });

  group('''fromJson''', () {
    test('''Should return a valid model when parsing JSON map''', () {
      // Arrange
      final Map<String, dynamic> jsonMap = json.decode(
        fixture('entity/movie_detail.json'),
      );
      // Act
      final result = MovieDetailModel.fromJson(jsonMap);
      // Assert
      expect(result, tMovieDetailModel);
    });
  });

  group('''toJson''', () {
    test('''Should return a JSON map containing the proper data ''', () {
      // Act
      final result = tMovieDetailModel.toJson();
      // Assert
      final expectedMap = json.decode(fixture('entity/movie_detail.json'));
      expect(result, expectedMap);
    });
  });
}
