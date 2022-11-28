import 'package:submission/domain/entities/watchlist.dart';

abstract class MovieLocalSource {
  Future<String> insertWatchlist(MovieWatchlist movie);
  Future<String> removeWatchlist(MovieWatchlist movie);
  Future<MovieWatchlist?> getWatchlist(int id);
  Future<List<MovieWatchlist>> getAllWatchlist();
}