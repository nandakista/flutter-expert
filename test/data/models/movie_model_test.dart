import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:submission/data/models/movie_model.dart';
import 'package:submission/domain/entities/movie.dart';

import '../../core/fixture/fixture_reader.dart';

void main() {
  const tMovieModel = MovieModel(
    adult: false,
    backdropPath: '/url.jpg',
    genreIds: [28, 14, 878],
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
  );

  test('''Should be a subclass of Movie Entity''', () {
    // Assert
    expect(tMovieModel, isA<Movie>());
  });

  group('''fromJson''', () {
    test('''Should return a valid model when parsing JSON map''', () {
      // Arrange
      final Map<String, dynamic> jsonMap = json.decode(
        fixture('entity/movie.json'),
      );
      // Act
      final result = MovieModel.fromJson(jsonMap);
      // Assert
      expect(result, tMovieModel);
    });
  });

  group('''toJson''', () {
    test('''Should return a JSON map containing the proper data ''', () {
      // Act
      final result = tMovieModel.toJson();
      // Assert
      final expectedMap = json.decode(fixture('entity/movie.json'));
      expect(result, expectedMap);
    });
  });
}
