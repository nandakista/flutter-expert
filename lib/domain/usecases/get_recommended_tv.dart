import 'package:dartz/dartz.dart';
import 'package:submission/domain/entities/tv.dart';
import 'package:submission/domain/repositories/tv_repository.dart';

import '../../core/error/failure.dart';

class GetRecommendedTv {
  final TvRepository repository;

  GetRecommendedTv({required this.repository});

  Future<Either<Failure, List<Tv>>> call(int id) {
    return repository.getRecommendedTv(id);
  }
}