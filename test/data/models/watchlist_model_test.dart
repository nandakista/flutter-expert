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
    isMovie: false,
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
    const tMovieWatchlistTvModel = WatchlistModel(
      id: 1,
      title: 'title',
      posterPath: 'posterPath',
      overview: 'overview',
      voteAverage: 9.0,
      isMovie: false,
    );
    const tMovieWatchlistMovieModel = WatchlistModel(
      id: 1,
      title: 'title',
      posterPath: 'posterPath',
      overview: 'overview',
      voteAverage: 9.0,
      isMovie: true,
    );
    test(
        '''Should return a JSON map with isMovie value is 1 when input is true''',
        () {
      // Act
      final result = tMovieWatchlistMovieModel.toJson();
      // Assert
      final expectedMap = json.decode(fixture('entity/watchlist_movie.json'));
      expect(result, expectedMap);
    });

    test(
        '''Should return a JSON map with isMovie value is 1 when input is true''',
        () {
      // Act
      final result = tMovieWatchlistTvModel.toJson();
      // Assert
      final expectedMap = json.decode(fixture('entity/watchlist_tv.json'));
      expect(result, expectedMap);
    });
  });
}
