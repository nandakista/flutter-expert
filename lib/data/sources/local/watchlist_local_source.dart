import 'package:submission/domain/entities/watchlist.dart';

abstract class WatchlistLocalSource {
  Future<String> insertWatchlist(Watchlist movie);
  Future<String> removeWatchlist(Watchlist movie);
  Future<Watchlist?> getWatchlist(int id);
  Future<List<Watchlist>> getAllWatchlist();
}