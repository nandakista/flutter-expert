import 'package:dartz/dartz.dart';
import 'package:submission/domain/entities/movie_detail.dart';

import '../../core/error/failure.dart';
import '../repositories/movie_repository.dart';

class RemoveWatchlistMovie {
  final MovieRepository repository;

  RemoveWatchlistMovie({required this.repository});

  Future<Either<Failure, String>> call(MovieDetail movie) {
    return repository.removeWatchlist(movie);
  }
}