import 'package:dartz/dartz.dart';

import '../../core/error/failure.dart';
import '../entities/movie.dart';
import '../repositories/movie_repository.dart';

class GetRecommendedMovies {
  final MovieRepository repository;

  GetRecommendedMovies({required this.repository});

  Future<Either<Failure, List<Movie>>> call(int id) {
    return repository.getRecommendedMovies(id);
  }
}
