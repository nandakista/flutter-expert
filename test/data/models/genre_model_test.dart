import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:submission/data/models/genre_model.dart';
import 'package:submission/domain/entities/genre.dart';

import '../../core/fixture/fixture_reader.dart';

void main() {
  const tGenreModel = GenreModel(id: 14, name: 'Fantasy');

  test('''Should be a subclass of Movie Detail Entity''', () {
    // Assert
    expect(tGenreModel, isA<Genre>());
  });

  group('''fromJson''', () {
    test('''Should return a valid model when parsing JSON map''', () {
      // Arrange
      final Map<String, dynamic> jsonMap = json.decode(
        fixture('entity/genre.json'),
      );
      // Act
      final result = GenreModel.fromJson(jsonMap);
      // Assert
      expect(result, tGenreModel);
    });
  });

  group('''toJson''', () {
    test('''Should return a JSON map containing the proper data ''', () {
      // Act
      final result = tGenreModel.toJson();
      // Assert
      final expectedMap = json.decode(fixture('entity/genre.json'));
      expect(result, expectedMap);
    });
  });
}