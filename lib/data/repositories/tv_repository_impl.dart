import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:submission/core/error/exception.dart';
import 'package:submission/core/error/failure.dart';
import 'package:submission/data/sources/local/watchlist_local_source.dart';
import 'package:submission/data/sources/server/tv_server_source.dart';
import 'package:submission/domain/entities/tv.dart';
import 'package:submission/domain/entities/tv_detail.dart';
import 'package:submission/domain/entities/watchlist.dart';
import 'package:submission/domain/repositories/tv_repository.dart';

class TvRepositoryImpl extends TvRepository {
  final TvServerSource serverSource;
  final WatchlistLocalSource localDataSource;

  TvRepositoryImpl({
    required this.serverSource,
    required this.localDataSource,
  });

  @override
  Future<Either<Failure, TvDetail>> getDetailTv(int id) async {
    try {
      final result = await serverSource.getTvDetail(id);
      return Right(result);
    } on ServerException {
      return const Left(ServerFailure(''));
    } on SocketException {
      return const Left(ConnectionFailure('No Internet Connection'));
    }
  }

  @override
  Future<Either<Failure, List<Tv>>> getOnAirTv() async {
    try {
      final result = await serverSource.getOnAirTv();
      return Right(result);
    } on ServerException {
      return const Left(ServerFailure(''));
    } on SocketException {
      return const Left(ConnectionFailure('No Internet Connection'));
    }
  }

  @override
  Future<Either<Failure, List<Tv>>> getPopularTv() async {
    try {
      final result = await serverSource.getPopularTv();
      return Right(result);
    } on ServerException {
      return const Left(ServerFailure(''));
    } on SocketException {
      return const Left(ConnectionFailure('No Internet Connection'));
    }
  }

  @override
  Future<Either<Failure, List<Tv>>> getRecommendedTv(int id) async {
    try {
      final result = await serverSource.getRecommendedTv(id);
      return Right(result);
    } on ServerException {
      return const Left(ServerFailure(''));
    } on SocketException {
      return const Left(ConnectionFailure('No Internet Connection'));
    }
  }

  @override
  Future<Either<Failure, List<Tv>>> getTopRatedTv() async {
    try {
      final result = await serverSource.getTopRatedTv();
      return Right(result);
    } on ServerException {
      return const Left(ServerFailure(''));
    } on SocketException {
      return const Left(ConnectionFailure('No Internet Connection'));
    }
  }

  @override
  Future<Either<Failure, List<Tv>>> searchTv(String query) async {
    try {
      final result = await serverSource.searchTv(query);
      return Right(result);
    } on ServerException {
      return const Left(ServerFailure(''));
    } on SocketException {
      return const Left(ConnectionFailure('No Internet Connection'));
    }
  }

  @override
  Future<Either<Failure, List<Tv>>> getAllWatchlist() async {
    try {
      final result = await localDataSource.getAllWatchlist();
      return Right(result
          .where((e) => !e.isMovie!)
          .map((data) => data.toTvEntity())
          .toList());
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    }
  }

  @override
  Future<bool> hasAddedToWatchlist(int id) async {
    final result = await localDataSource.getWatchlist(id);
    return result != null;
  }

  @override
  Future<Either<Failure, String>> removeWatchlist(TvDetail tv) async {
    try {
      final result = await localDataSource
          .removeWatchlist(Watchlist.fromTvEntity(data: tv, isMovie: false));
      return Right(result);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, String>> saveWatchlist(TvDetail tv) async {
    try {
      final result = await localDataSource
          .insertWatchlist(Watchlist.fromTvEntity(data: tv, isMovie: false));
      return Right(result);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    }
  }
}
