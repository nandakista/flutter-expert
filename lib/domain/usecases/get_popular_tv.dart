import 'package:dartz/dartz.dart';
import 'package:submission/domain/entities/tv.dart';
import 'package:submission/domain/repositories/tv_repository.dart';

import '../../core/error/failure.dart';

class GetPopularTv {
  final TvRepository repository;

  GetPopularTv({required this.repository});

  Future<Either<Failure, List<Tv>>> call() {
    return repository.getPopularTv();
  }
}