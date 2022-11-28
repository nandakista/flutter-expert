import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:submission/data/models/season_model.dart';
import 'package:submission/domain/entities/season.dart';

import '../../core/fixture/fixture_reader.dart';

void main() {
  const tSeasonModel = SeasonModel(
    airDate: '2021-11-06',
    episodeCount: 9,
    id: 134187,
    name: 'Season 1',
    overview: 'overview',
    posterPath: '/url.jpg',
    seasonNumber: 1,
  );

  test('''Should be a subclass of Tv Entity''', () {
    // Assert
    expect(tSeasonModel, isA<Season>());
  });

  group('''fromJson''', () {
    test('''Should return a valid model when parsing JSON map''', () {
      // Arrange
      final Map<String, dynamic> jsonMap = json.decode(
        fixture('entity/season.json'),
      );
      // Act
      final result = SeasonModel.fromJson(jsonMap);
      // Assert
      expect(result, tSeasonModel);
    });
  });

  group('''toJson''', () {
    test('''Should return a JSON map containing the proper data ''', () {
      // Act
      final result = tSeasonModel.toJson();
      // Assert
      final expectedMap = json.decode(fixture('entity/season.json'));
      expect(result, expectedMap);
    });
  });
}
