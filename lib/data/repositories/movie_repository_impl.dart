import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:submission/core/error/failure.dart';
import 'package:submission/data/sources/server/movie_server_source.dart';
import 'package:submission/domain/entities/movie.dart';
import 'package:submission/domain/entities/movie_detail.dart';
import 'package:submission/domain/repositories/movie_repository.dart';

import '../../core/error/exception.dart';

class MovieRepositoryImpl implements MovieRepository {
  final MovieServerSource serverSource;

  MovieRepositoryImpl({required this.serverSource});

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


  // -------- LOCAL
  @override
  Future<Either<Failure, List<Movie>>> getWatchlistMovies() {
    // TODO: implement getWatchlistMovies
    throw UnimplementedError();
  }

  @override
  Future<bool> isAddedToWatchlist(int id) {
    // TODO: implement isAddedToWatchlist
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, String>> removeWatchlist(MovieDetail movie) {
    // TODO: implement removeWatchlist
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, String>> saveWatchlist(MovieDetail movie) {
    // TODO: implement saveWatchlist
    throw UnimplementedError();
  }
}
