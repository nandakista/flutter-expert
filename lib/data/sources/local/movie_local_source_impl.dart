import 'package:submission/core/database/dao/watchlist_dao.dart';
import 'package:submission/data/sources/local/movie_local_source.dart';
import 'package:submission/domain/entities/movie_watchlist.dart';

import '../../../core/error/exception.dart';
import '../../models/movie_watchlist_model.dart';

class MovieLocalSourceImpl extends MovieLocalSource {
  final WatchlistDao dao;

  MovieLocalSourceImpl({required this.dao});

  @override
  Future<MovieWatchlist?> getWatchlist(int id) async {
    final result = await dao.getWatchlist(id);
    if (result != null) {
      return MovieWatchlistModel.fromJson(result);
    } else {
      return null;
    }
  }

  @override
  Future<List<MovieWatchlist>> getAllWatchlist() async {
    try {
      final result = await dao.getAllWatchlist();
      return result.map((data) => MovieWatchlistModel.fromJson(data)).toList();
    } catch (e) {
      throw DatabaseException(e.toString());
    }
  }

  @override
  Future<String> insertWatchlist(MovieWatchlist movie) async {
    try {
      await dao.insertWatchlist(movie);
      return 'Added to Watchlist';
    } catch (e) {
      throw DatabaseException(e.toString());
    }
  }

  @override
  Future<String> removeWatchlist(MovieWatchlist movie) async {
    try {
      await dao.removeWatchlist(movie);
      return 'Removed from Watchlist';
    } catch (e) {
      throw DatabaseException(e.toString());
    }
  }
}
