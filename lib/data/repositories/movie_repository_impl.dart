import 'dart:io';
import 'package:dartz/dartz.dart';

import '../../core/error/exception.dart';
import '../../core/error/failure.dart';
import '../../domain/entities/movie.dart';
import '../../domain/entities/movie_detail.dart';
import '../../domain/entities/watchlist.dart';
import '../../domain/repositories/movie_repository.dart';
import '../sources/local/watchlist_local_source.dart';
import '../sources/server/movie_server_source.dart';

class MovieRepositoryImpl implements MovieRepository {
  final MovieServerSource serverSource;
  final WatchlistLocalSource localDataSource;

  MovieRepositoryImpl({
    required this.serverSource,
    required this.localDataSource,
  });

  @override
  Future<Either<Failure, MovieDetail>> getDetailMovie(int id) async {
    try {
      final result = await serverSource.getMovieDetail(id);
      return Right(result);
    } on ServerException {
      return const Left(ServerFailure(''));
    } on SocketException {
      return const Left(ConnectionFailure('No Internet Connection'));
    }
  }

  @override
  Future<Either<Failure, List<Movie>>> getRecommendedMovies(int id) async {
    try {
      final result = await serverSource.getRecommendedMovies(id);
      return Right(result);
    } on ServerException {
      return const Left(ServerFailure(''));
    } on SocketException {
      return const Left(ConnectionFailure('No Internet Connection'));
    }
  }

  @override
  Future<Either<Failure, List<Movie>>> getNowPlayingMovies() async {
    try {
      final result = await serverSource.getNowPlayingMovies();
      return Right(result);
    } on ServerException {
      return const Left(ServerFailure(''));
    } on SocketException {
      return const Left(ConnectionFailure('No Internet Connection'));
    }
  }

  @override
  Future<Either<Failure, List<Movie>>> getPopularMovies() async {
    try {
      final result = await serverSource.getPopularMovies();
      return Right(result);
    } on ServerException {
      return const Left(ServerFailure(''));
    } on SocketException {
      return const Left(ConnectionFailure('No Internet Connection'));
    }
  }

  @override
  Future<Either<Failure, List<Movie>>> getTopRatedMovies() async {
    try {
      final result = await serverSource.getTopRatedMovies();
      return Right(result);
    } on ServerException {
      return const Left(ServerFailure(''));
    } on SocketException {
      return const Left(ConnectionFailure('No Internet Connection'));
    }
  }

  @override
  Future<Either<Failure, List<Movie>>> searchMovies(String query) async {
    try {
      final result = await serverSource.searchMovies(query);
      return Right(result);
    } on ServerException {
      return const Left(ServerFailure(''));
    } on SocketException {
      return const Left(ConnectionFailure('No Internet Connection'));
    }
  }

  @override
  Future<Either<Failure, List<Movie>>> getAllWatchlist() async {
    try {
      final result = await localDataSource.getAllWatchlist();
      return Right(result.map((data) => data.toMovieEntity()).toList());
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
  Future<Either<Failure, String>> removeWatchlist(MovieDetail movie) async {
    try {
      final result = await localDataSource
          .removeWatchlist(Watchlist.fromMovieEntity(movie));
      return Right(result);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, String>> saveWatchlist(MovieDetail movie) async {
    try {
      final result = await localDataSource
          .insertWatchlist(Watchlist.fromMovieEntity(movie));
      return Right(result);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    }
  }
}
