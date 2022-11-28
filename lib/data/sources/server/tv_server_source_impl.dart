import 'package:submission/data/sources/server/tv_server_source.dart';
import 'package:submission/domain/entities/tv.dart';
import 'package:submission/domain/entities/tv_detail.dart';

class TvServerSourceImpl extends TvServerSource {
  @override
  Future<List<Tv>> getOnAirTv() async {
    // TODO: implement getNowPlayingTv
    throw UnimplementedError();
  }

  @override
  Future<List<Tv>> getPopularTv() async {
    // TODO: implement getPopularTv
    throw UnimplementedError();
  }

  @override
  Future<List<Tv>> getRecommendedTv(int id) async {
    // TODO: implement getRecommendedTv
    throw UnimplementedError();
  }

  @override
  Future<List<Tv>> getTopRatedTv() async {
    // TODO: implement getTopRatedTv
    throw UnimplementedError();
  }

  @override
  Future<TvDetail> getTvDetail(int id) async {
    // TODO: implement getTvDetail
    throw UnimplementedError();
  }

  @override
  Future<List<Tv>> searchTv(String query) async {
    // TODO: implement searchTv
    throw UnimplementedError();
  }
}
