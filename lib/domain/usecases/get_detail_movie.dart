import 'package:dartz/dartz.dart';

import '../../core/error/failure.dart';
import '../entities/movie_detail.dart';
import '../repositories/movie_repository.dart';

class GetDetailMovie {
  final MovieRepository repository;

  GetDetailMovie({required this.repository});

  Future<Either<Failure, MovieDetail>> call(int id) {
    return repository.getDetailMovie(id);
  }
}
