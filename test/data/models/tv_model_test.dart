import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:submission/data/models/tv_model.dart';
import 'package:submission/domain/entities/tv.dart';

import '../../core/fixture/fixture_reader.dart';

void main() {
  const tTvModel = TvModel(
    backdropPath: '/url.jpg',
    firstAirDate: "2013-12-02",
    genreIds: [16, 35, 10765, 10759],
    id: 60625,
    name: 'Rick and Morty',
    originCountry: [
      'US'
    ],
    originalLanguage: 'en',
    originalName: 'Rick and Morty',
    overview: 'overview',
    popularity: 1377.974,
    posterPath: '/url.jpg',
    voteAverage: 8.7,
    voteCount: 7426,
  );

  test('''Should be a subclass of Tv Entity''', () {
    // Assert
    expect(tTvModel, isA<Tv>());
  });

  group('''fromJson''', () {
    test('''Should return a valid model when parsing JSON map''', () {
      // Arrange
      final Map<String, dynamic> jsonMap = json.decode(
        fixture('entity/tv.json'),
      );
      // Act
      final result = TvModel.fromJson(jsonMap);
      // Assert
      expect(result, tTvModel);
    });
  });

  group('''toJson''', () {
    test('''Should return a JSON map containing the proper data ''', () {
      // Act
      final result = tTvModel.toJson();
      // Assert
      final expectedMap = json.decode(fixture('entity/tv.json'));
      expect(result, expectedMap);
    });
  });
}
