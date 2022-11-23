import 'package:dartz/dartz.dart';

import '../../core/error/failure.dart';
import '../entities/movie.dart';
import '../repositories/movie_repository.dart';

class SearchMovie {
  final MovieRepository repository;

  SearchMovie({required this.repository});

  Future<Either<Failure, List<Movie>>> call(String query) {
    return repository.searchMovies(query);
  }
}
