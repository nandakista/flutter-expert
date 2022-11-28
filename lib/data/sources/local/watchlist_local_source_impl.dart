import 'package:submission/core/database/dao/watchlist_dao.dart';
import 'package:submission/data/sources/local/watchlist_local_source.dart';
import 'package:submission/domain/entities/watchlist.dart';

import '../../../core/error/exception.dart';
import '../../models/watchlist_model.dart';

class WatchlistLocalSourceImpl extends WatchlistLocalSource {
  final WatchlistDao dao;

  WatchlistLocalSourceImpl({required this.dao});

  @override
  Future<Watchlist?> getWatchlist(int id) async {
    final result = await dao.getWatchlist(id);
    if (result != null) {
      return WatchlistModel.fromJson(result);
    } else {
      return null;
    }
  }

  @override
  Future<List<Watchlist>> getAllWatchlist() async {
    try {
      final result = await dao.getAllWatchlist();
      return result.map((data) => WatchlistModel.fromJson(data)).toList();
    } catch (e) {
      throw DatabaseException(e.toString());
    }
  }

  @override
  Future<String> insertWatchlist(Watchlist movie) async {
    try {
      await dao.insertWatchlist(movie);
      return 'Added to Watchlist';
    } catch (e) {
      throw DatabaseException(e.toString());
    }
  }

  @override
  Future<String> removeWatchlist(Watchlist movie) async {
    try {
      await dao.removeWatchlist(movie);
      return 'Removed from Watchlist';
    } catch (e) {
      throw DatabaseException(e.toString());
    }
  }
}
