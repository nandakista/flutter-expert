import 'package:sqflite/sqflite.dart';
import 'package:submission/core/database/app_database.dart';
import 'package:submission/data/models/watchlist_model.dart';

import '../../../domain/entities/watchlist.dart';

class WatchlistDao {
  static const String tableName = 'watchlist';
  static const String id = 'id';
  static const String title = 'title';
  static const String posterPath = 'posterPath';
  static const String overview = 'overview';
  static const String voteAverage = 'voteAverage';

  Future<int> insertWatchlist(MovieWatchlist movie) async {
    Database? db = await AppDatabase().database;
    return await db!.insert(
      tableName,
      MovieWatchlistModel(
        id: movie.id,
        title: movie.title,
        posterPath: movie.posterPath,
        overview: movie.overview,
        voteAverage: movie.voteAverage,
      ).toJson(),
    );
  }

  Future<int> removeWatchlist(MovieWatchlist movie) async {
    Database? db = await AppDatabase().database;
    return await db!.delete(
      tableName,
      where: '$id = ?',
      whereArgs: [movie.id],
    );
  }

  Future<Map<String, dynamic>?> getWatchlist(int movieId) async {
    Database? db = await AppDatabase().database;
    final result = await db!.query(
      tableName,
      where: '$id = ?',
      whereArgs: [movieId],
    );
    if (result.isNotEmpty) return result.first;
    return null;
  }

  Future<List<Map<String, dynamic>>> getAllWatchlist() async {
    Database? db = await AppDatabase().database;
    final List<Map<String, dynamic>> results = await db!.query(tableName);
    return results;
  }
}
