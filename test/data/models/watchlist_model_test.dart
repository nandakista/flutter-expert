import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:submission/data/models/watchlist_model.dart';
import 'package:submission/domain/entities/watchlist.dart';

import '../../core/fixture/fixture_reader.dart';

void main() {
  const tMovieWatchlistModel = WatchlistModel(
    id: 1,
    title: 'title',
    posterPath: 'posterPath',
    overview: 'overview',
    voteAverage: 9.0,
  );

  test('''Should be a subclass of Movie Detail Entity''', () {
    // Assert
    expect(tMovieWatchlistModel, isA<Watchlist>());
  });

  group('''fromJson''', () {
    test('''Should return a valid model when parsing JSON map''', () {
      // Arrange
      final Map<String, dynamic> jsonMap = json.decode(
        fixture('entity/watchlist.json'),
      );
      // Act
      final result = WatchlistModel.fromJson(jsonMap);
      // Assert
      expect(result, tMovieWatchlistModel);
    });
  });

  group('''toJson''', () {
    test('''Should return a JSON map containing the proper data ''', () {
      // Act
      final result = tMovieWatchlistModel.toJson();
      // Assert
      final expectedMap = json.decode(fixture('entity/watchlist.json'));
      expect(result, expectedMap);
    });
  });
}
