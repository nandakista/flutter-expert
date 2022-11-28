import 'package:dartz/dartz.dart';
import 'package:submission/core/error/failure.dart';
import 'package:submission/domain/entities/tv.dart';
import 'package:submission/domain/entities/tv_detail.dart';
import 'package:submission/domain/repositories/tv_repository.dart';

class TvRepositoryImpl extends TvRepository{
  @override
  Future<Either<Failure, List<Tv>>> getAllWatchlist() async {
    // TODO: implement getAllWatchlist
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, TvDetail>> getDetailTv(int id) async {
    // TODO: implement getDetailTv
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, List<Tv>>> getOnAirTv() async {
    // TODO: implement getOnAirTv
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, List<Tv>>> getPopularTv() async {
    // TODO: implement getPopularTv
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, List<Tv>>> getRecommendedTv(int id) async {
    // TODO: implement getRecommendedTv
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, List<Tv>>> getTopRatedTv() async {
    // TODO: implement getTopRatedTv
    throw UnimplementedError();
  }

  @override
  Future<bool> hasAddedToWatchlist(int id) async {
    // TODO: implement hasAddedToWatchlist
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, String>> removeWatchlist(TvDetail tv) async {
    // TODO: implement removeWatchlist
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, String>> saveWatchlist(TvDetail tv) async {
    // TODO: implement saveWatchlist
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, List<Tv>>> searchTv(String query) async {
    // TODO: implement searchTv
    throw UnimplementedError();
  }
}