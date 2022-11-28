import 'package:submission/domain/entities/tv.dart';
import 'package:submission/domain/entities/tv_detail.dart';

abstract class TvServerSource {
  Future<TvDetail> getTvDetail(int id);
  Future<List<Tv>> getRecommendedTv(int id);
  Future<List<Tv>> getOnAirTv();
  Future<List<Tv>> getPopularTv();
  Future<List<Tv>> getTopRatedTv();
  Future<List<Tv>> searchTv(String query);
}