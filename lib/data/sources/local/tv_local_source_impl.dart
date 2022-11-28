import 'package:submission/data/sources/local/tv_local_source.dart';
import 'package:submission/domain/entities/watchlist.dart';

class TvLocalSourceImpl extends TvLocalSource {
  @override
  Future<List<Watchlist>> getAllWatchlist() {
    // TODO: implement getAllWatchlist
    throw UnimplementedError();
  }

  @override
  Future<Watchlist?> getWatchlist(int id) {
    // TODO: implement getWatchlist
    throw UnimplementedError();
  }

  @override
  Future<String> insertWatchlist(Watchlist movie) {
    // TODO: implement insertWatchlist
    throw UnimplementedError();
  }

  @override
  Future<String> removeWatchlist(Watchlist movie) {
    // TODO: implement removeWatchlist
    throw UnimplementedError();
  }
}