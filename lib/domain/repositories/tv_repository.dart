import 'package:dartz/dartz.dart';
import 'package:submission/domain/entities/tv.dart';
import 'package:submission/domain/entities/tv_detail.dart';

import '../../core/error/failure.dart';

abstract class TvRepository {
  Future<Either<Failure, List<Tv>>> getOnAirTv();
  Future<Either<Failure, List<Tv>>> getPopularTv();
  Future<Either<Failure, List<Tv>>> getTopRatedTv();
  Future<Either<Failure, TvDetail>> getDetailTv(int id);
  Future<Either<Failure, List<Tv>>> getRecommendedTv(int id);
  Future<Either<Failure, List<Tv>>> searchTv(String query);
  Future<Either<Failure, String>> saveWatchlist(TvDetail tv);
  Future<Either<Failure, String>> removeWatchlist(TvDetail tv);
  Future<bool> hasAddedToWatchlist(int id);
  Future<Either<Failure, List<Tv>>> getAllWatchlist();
}
