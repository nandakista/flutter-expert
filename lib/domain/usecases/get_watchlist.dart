import 'package:dartz/dartz.dart';

import '../../core/error/failure.dart';
import '../entities/movie.dart';
import '../repositories/movie_repository.dart';

class GetWatchlist {
  final MovieRepository repository;

  GetWatchlist({required this.repository});

  Future<Either<Failure, List<Movie>>> call() {
    return repository.getAllWatchlist();
  }
}