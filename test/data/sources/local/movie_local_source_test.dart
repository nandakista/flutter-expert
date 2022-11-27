import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:submission/core/database/dao/watchlist_dao.dart';
import 'package:submission/core/error/exception.dart';
import 'package:submission/data/models/movie_watchlist_model.dart';
import 'package:submission/data/sources/local/movie_local_source_impl.dart';
import 'package:submission/domain/entities/movie_watchlist.dart';

import 'movie_local_source_test.mocks.dart';

@GenerateMocks([WatchlistDao])
void main() {
  late MovieLocalSourceImpl source;
  late MockWatchlistDao mockWatchlistDao;

  setUp(() {
    mockWatchlistDao = MockWatchlistDao();
    source = MovieLocalSourceImpl(dao: mockWatchlistDao);
  });

  group('''Save Watchlist''', () {
    const tMovieWatchlist = MovieWatchlist(
      id: 1,
      title: 'title',
      posterPath: 'posterPath',
      overview: 'overview',
      voteAverage: 8.9,
    );
    test(
      '''Should return success message when successfully insert to database''',
      () async {
        // Arrange
        when(mockWatchlistDao.insertWatchlist(tMovieWatchlist))
            .thenAnswer((_) async => 1);
        // Act
        final result = await source.insertWatchlist(tMovieWatchlist);
        // Assert
        expect(result, 'Added to Watchlist');
      },
    );

    test('should throw DatabaseException when failed insert to database',
        () async {
      // Arrange
      when(mockWatchlistDao.insertWatchlist(tMovieWatchlist))
          .thenThrow(Exception());
      // Act
      final call = source.insertWatchlist(tMovieWatchlist);
      // Assert
      expect(() => call, throwsA(isA<DatabaseException>()));
    });
  });

  group('Remove Watchlist', () {
    const tMovieWatchlist = MovieWatchlist(
      id: 1,
      title: 'title',
      posterPath: 'posterPath',
      overview: 'overview',
      voteAverage: 8.9,
    );
    test('Should return success message when successfully remove from database',
        () async {
      // Arrange
      when(mockWatchlistDao.removeWatchlist(tMovieWatchlist))
          .thenAnswer((_) async => 1);
      // Act
      final result = await source.removeWatchlist(tMovieWatchlist);
      // Assert
      expect(result, 'Removed from Watchlist');
    });

    test('Should throw DatabaseException when failed remove from database',
        () async {
      // Arrange
      when(mockWatchlistDao.removeWatchlist(tMovieWatchlist))
          .thenThrow(Exception());
      // Act
      final call = source.removeWatchlist(tMovieWatchlist);
      // Assert
      expect(() => call, throwsA(isA<DatabaseException>()));
    });
  });

  group('Get All Watchlist', () {
    final tWatchlistMovieMap = {
      'id': 1,
      'title': 'title',
      'posterPath': 'posterPath',
      'overview': 'overview',
      'voteAverage': 8.9,
    };

    const tMovieWatchlist = MovieWatchlistModel(
      id: 1,
      title: 'title',
      posterPath: 'posterPath',
      overview: 'overview',
      voteAverage: 8.9,
    );

    test('should return list of MovieTable from database', () async {
      // Arrange
      when(mockWatchlistDao.getAllWatchlist())
          .thenAnswer((_) async => [tWatchlistMovieMap]);
      // Act
      final result = await source.getAllWatchlist();
      // Assert
      expect(result, [tMovieWatchlist]);
    });
  });

  group('Get Movie Detail By Id', () {
    const tId = 1;
    final tWatchlistMovieMap = {
      'id': 1,
      'title': 'title',
      'posterPath': 'posterPath',
      'overview': 'overview',
      'voteAverage': 8.9,
    };
    const tMovieWatchlist = MovieWatchlistModel(
      id: 1,
      title: 'title',
      posterPath: 'posterPath',
      overview: 'overview',
      voteAverage: 8.9,
    );

    test('Should return Movie Watchlist when exist in database', () async {
      // Arrange
      when(mockWatchlistDao.getWatchlist(tId))
          .thenAnswer((_) async => tWatchlistMovieMap);
      // Act
      final result = await source.getWatchlist(tId);
      // Assert
      expect(result, tMovieWatchlist);
    });

    test('Should return null when data is not exist in database', () async {
      // Arrange
      when(mockWatchlistDao.getWatchlist(tId)).thenAnswer((_) async => null);
      // Act
      final result = await source.getWatchlist(tId);
      // Assert
      expect(result, null);
    });
  });
}
